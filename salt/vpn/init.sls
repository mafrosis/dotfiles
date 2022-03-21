include:
  - vpn.nordvpn

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
      - file: novpn-systemd-script

/etc/systemd/system/nordvpn-connect.service:
  file.managed:
    - contents: |
        [Unit]
        Description=Configure and connect NordVPN
        Wants=network-online.target
        After=network-online.target

        [Service]
        Type=oneshot
        User=mafro
        ExecStart=/usr/bin/nordvpn connect
        #ExecStart=ip route add 192.168.2.0/24 via 192.168.1.1
        RemainAfterExit=true
        ExecStop=/usr/bin/nordvpn disconnect

        [Install]
        WantedBy=default.target
    - user: root
    - mode: 644

nordvpn-connect:
  service.enabled
