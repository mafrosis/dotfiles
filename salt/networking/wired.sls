include:
  - networking.systemd


# Create networkd config for wired device
systemd-networkd-wired:
  file.managed:
    - name: /etc/systemd/network/00-wired.network
    - contents: |
        [Match]
        Name=e*

        [Network]
        DHCP=ipv4

        [DHCPv4]
        {% if grains['host'] == 'locke' %}
        UseDNS=false
        {% else %}
        UseDomains=true
        {% endif %}
    - require_in:
      - service: systemd-networkd
      - service: systemd-resolved
