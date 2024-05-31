1pass-apt-deps:
  pkg.installed:
    - names:
      - apt-transport-https
      - ca-certificates
      - curl
      - gnupg2

/etc/apt/keyrings:
  file.directory

1pass-apt-gpg:
  file.managed:
    - name: /tmp/1pass.gpg
    - source: https://downloads.1password.com/linux/keys/1password.asc
    - source_hash: md5=2ceb01ffecc172f6f0ee4d581b38b2be
    - keep_source: false
  cmd.wait:
    - name: cat /tmp/1pass.gpg | gpg --dearmor --batch --yes -o /usr/share/keyrings/1password-archive-keyring.gpg
    - watch:
      - file: 1pass-apt-gpg

1pass-pkgrepo:
  pkgrepo.managed:
    - humanname: 1pass
    - name: deb [arch={{ grains['osarch'] }} signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/{{ grains['osarch'] }} stable main
    - file: /etc/apt/sources.list.d/1password.list
    - require_in:
      - pkg: 1password-cli

/etc/debsig/policies/AC2D62742012EA22:
  file.directory:
    - makedirs: true

/etc/debsig/policies/AC2D62742012EA22/1password.pol:
  file.managed:
    - source: https://downloads.1password.com/linux/debian/debsig/1password.pol
    - source_hash: md5=c123179ce41eaa781777b9b47d46f18b
    - require_in:
      - pkg: 1password-cli

/usr/share/debsig/keyrings/AC2D62742012EA22:
  file.directory:
    - makedirs: true

/tmp/1password.asc:
  file.managed:
    - source: https://downloads.1password.com/linux/keys/1password.asc
    - source_hash: md5=2ceb01ffecc172f6f0ee4d581b38b2be
  cmd.run:
    - name: cat /tmp/1password.asc | gpg --dearmor --batch --yes -o /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg
    - watch:
      - file: /tmp/1password.asc
    - require_in:
      - pkg: 1password-cli

1password-cli:
  pkg.installed
