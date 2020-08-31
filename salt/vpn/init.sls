include:
  - vpn.nordvpn

novpn-script:
  file.managed:
    - name: /usr/local/bin/novpn.bash
    - source: salt://vpn/novpn.bash
    - user: root
    - mode: 744

novpn-systemd-script:
  file.managed:
    - name: /etc/systemd/system/novpn.service
    - contents: |
        [Unit]
        Description=NoVPN service
        After=network.target

        [Service]
        ExecStart=/usr/local/bin/novpn.bash

        [Install]
        WantedBy=multi-user.target
    - user: root
    - mode: 744

novpn-service-enable:
  service.enabled:
    - name: novpn
    - require:
      - file: novpn-systemd-script
