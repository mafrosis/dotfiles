{% set user = pillar.get('login_user', 'mafro') %}

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

nordvpn-adduser-group:
  group.present:
    - name: nordvpn
    - addusers:
      - {{ user }}

nordvpn-config-tech:
  cmd.run:
    - name: nordvpn set technology NordLynx
    - unless: nordvpn settings | grep NORDLYNX
    - runas: mafro

nordvpn-config-dns:
  cmd.run:
    - name: nordvpn set dns 192.168.1.198
    - unless: "nordvpn settings | grep 'DNS: 192.168.1.198'"
    - runas: mafro

nordvpn-config-lan-discovery:
  cmd.run:
    - name: nordvpn set lan-discovery on
    - unless: "nordvpn settings | grep 'LAN Discovery: enabled'"
    - runas: mafro

nordvpn-config-allow-ssh:
  cmd.run:
    - name: nordvpn whitelist add port 22 protocol TCP
    - unless: nordvpn settings | grep '22 (TCP)'
    - runas: mafro

nordvpn-config-allow-dns:
  cmd.run:
    - name: nordvpn whitelist add port 53
    - unless: nordvpn settings | grep '53 (UDP|TCP)'
    - runas: mafro

nordvpn-config-allow-salt:
  cmd.run:
    - name: nordvpn whitelist add ports 4505 4506 protocol TCP
    - unless: nordvpn settings | grep '4505 - 4506 (TCP)'
    - runas: mafro

nordvpn-config-allow-mqtt:
  cmd.run:
    - name: nordvpn whitelist add port 1883 protocol TCP
    - unless: nordvpn settings | grep '1883 (TCP)'
    - runas: mafro

nordvpn-config-allow-samba:
  cmd.run:
    - name: |
        nordvpn whitelist add ports 137 138 protocol UDP
        nordvpn whitelist add port 139 protocol TCP
        nordvpn whitelist add port 445 protocol TCP
    - unless: nordvpn settings | grep '445 (TCP)'
    - runas: mafro

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
