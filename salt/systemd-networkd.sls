# https://raspberrypi.stackexchange.com/questions/108592/use-systemd-networkd-for-general-networking
# https://wiki.archlinux.org/title/systemd-networkd
# https://wiki.archlinux.org/title/systemd-resolved
#
/etc/network/interfaces:
  file.rename:
    - source: /etc/network/interfaces.save

systemd-networkd:
  service.running:
    - enable: true
    - reload: true

/etc/systemd/network/00-wired.network:
  file.managed:
    - contents: |
        [Match]
        Name=e*

        [Network]
        DHCP=ipv4
        DNS=192.168.1.1
        Domains=eggs

        [DHCP]
        UseDomains=route

systemd-resolved:
  service.running:
    - enable: true
    - reload: true

{% if grains['host'] == 'ringil' %}
/etc/systemd/resolved.conf.d/dns.conf:
  file.managed:
    - makedirs: true
    - contents: |
        [Resolve]
        DNS=1.1.1.1 1.0.0.1
        FallbackDNS=8.8.8.8
        DNSStubListener=no
{% endif %}
