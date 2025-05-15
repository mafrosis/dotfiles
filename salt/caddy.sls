include:
  - step.root-ca-cert


caddy-apt-deps:
  pkg.installed:
    - names:
      - debian-keyring
      - debian-archive-keyring
      - apt-transport-https
      - ca-certificates
      - curl

caddy-apt-keyrings:
  file.directory:
    - name: /etc/apt/keyrings

caddy-apt-gpg:
  file.managed:
    - name: /tmp/caddy.gpg
    - source: https://dl.cloudsmith.io/public/caddy/stable/gpg.key
    - source_hash: md5=2d4a43cd25514f24ddf35467d6abfe5f
    - keep_source: false
  cmd.wait:
    - name: cat /tmp/caddy.gpg | gpg --dearmor -o /etc/apt/keyrings/caddy.gpg
    - watch:
      - file: caddy-apt-gpg

caddy-pkgrepo:
  pkgrepo.managed:
    - humanname: caddy
    - name: deb [signed-by=/etc/apt/keyrings/caddy.gpg] https://dl.cloudsmith.io/public/caddy/testing/deb/debian any-version main
    - file: /etc/apt/sources.list.d/caddy.list
    - require_in:
      - pkg: caddy

caddy:
  pkg:
    - installed
  user.present:
    - optional_groups:
      - step-ca
      - video
      - rtorrent
    - require:
      - pkg: caddy
      - group: step-ca
  service.running:
    - restart: true
    - require:
      - user: caddy
