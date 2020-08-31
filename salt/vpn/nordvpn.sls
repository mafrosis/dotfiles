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
    - user: mafro
    - require:
      - pkg: nordvpn-install
