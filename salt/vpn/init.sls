include:
  - vpn.nordvpn

# Do some IP tables changes:
# - force egress port 22 traffic over LAN
# - drop ingress port 22 traffic from VPN
novpn-script:
  file.managed:
    - name: /usr/local/bin/novpn.bash
    - source: salt://vpn/novpn.bash
    - user: root
    - mode: 744

/etc/systemd/system/novpn.service:
  file.managed:
    - contents: |
        [Unit]
        Description=Setup some routes that should avoid the VPN
        After=network.target

        [Service]
        ExecStart=/usr/local/bin/novpn.bash

        [Install]
        WantedBy=multi-user.target
    - user: root
    - mode: 644

novpn-service-enable:
  service.enabled:
    - name: novpn
    - require:
      - file: /etc/systemd/system/novpn.service
