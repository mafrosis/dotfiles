# https://raspberrypi.stackexchange.com/questions/108592/use-systemd-networkd-for-general-networking
# https://wiki.archlinux.org/title/systemd-networkd
# https://wiki.archlinux.org/title/systemd-resolved

# Remove Debian networking
ifupdown:
  pkg.purged

# Remove dhcpcd
dhcpcd:
  pkg.purged
dhcpcd5:
  pkg.purged
isc-dhcp-client:
  pkg.purged
isc-dhcp-common:
  pkg.purged 

/etc/network:
  file.absent
/etc/dhcp:
  file.absent

# Remove rsyslog as irrelevant & cause of double logging
# https://raspberrypi.stackexchange.com/q/108592/94114#comment219607_108593
rsyslog:
  pkg.purged

# Remove the avahi-daemon & libnss-mdns, which can conflict on NSS interface to systemd-resolved
avahi-daemon:
  pkg.purged
libnss-mdns:
  service.disabled

# Remove openresolv which conflicts with systemd-resolved
openresolv:
  pkg.purged

systemd-networkd-apt-hold-pkgs:
  pkg.held:
    - pkgs:
      - ifupdown
      - dhcpcd5
      - isc-dhcp-client
      - isc-dhcp-common
      - rsyslog
      - avahi-daemon
      - libnss-mdns
      - raspberrypi-net-mods
      - openresolv

systemd-networkd:
  service.running:
    - enable: true
    - restart: true

# Install NSS interface to systemd-resolved
libnss-resolve:
  pkg.installed

# Force synlink /etc/resolv.conf to systemd-resolved config
/etc/resolv.conf:
  file.symlink:
    - target: /run/systemd/resolve/stub-resolv.conf
    - force: true

systemd-resolved:
  service.running:
    - enable: true
    - restart: true
    - watch:
      - file: /etc/resolv.conf


# Special DNS configuration for locke, which hosts the pihole DNS server
{% if grains['host'] == 'locke' %}

# Configure systemd-resolved to use Cloudflare public DNS
# Disable the stub server which binds port 53; pihole uses port 53
/etc/systemd/resolved.conf.d/dns.conf:
  file.managed:
    - makedirs: true
    - contents: |
        [Resolve]
        DNS=1.1.1.1 1.0.0.1
        FallbackDNS=8.8.8.8
        DNSStubListener=no

extend:
  systemd-resolved:
    service.running:
      - watch:
        - file: /etc/systemd/resolved.conf.d/dns.conf

  # Do not use the stub resolver on locke
  # https://github.com/systemd/systemd/issues/14700
  /etc/resolv.conf:
    file.symlink:
      - target: /run/systemd/resolve/resolv.conf

{% endif %}
