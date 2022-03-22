nordvpn-apt-deps:
  pkg.installed:
    - names:
      - openvpn
      - wireguard

nordvpn-pkgrepo:
  pkgrepo.managed:
    - humanname: NordVPN
    - name: deb https://repo.nordvpn.com/deb/nordvpn/debian stable main
    - file: /etc/apt/sources.list.d/nordvpn.list
    - key_url: https://repo.nordvpn.com/gpg/nordvpn_public.asc
    - require_in:
      - pkg: nordvpn-install

nordvpn-install:
  pkg.installed:
    - name: nordvpn
    - require:
      - pkg: nordvpn-apt-deps

nordvpn-configure:
  cmd.run:
    - name: |
        # technology & whitelisting
        nordvpn set technology NordLynx
        nordvpn set dns 192.168.1.167

        # whitelisting
        nordvpn whitelist add port 22 protocol TCP
        nordvpn whitelist add port 53
        nordvpn whitelist add ports 137 138 protocol UDP
        nordvpn whitelist add port 139 protocol TCP
        nordvpn whitelist add port 445 protocol TCP
    - runas: mafro
    - require:
      - pkg: nordvpn-install

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
