include:
  - step.root-ca-cert


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
    - watch:
      - file: /etc/caddy/Caddyfile
    - require:
      - user: caddy

/etc/caddy/Caddyfile:
  file.managed:
    - contents: |
        jorg.eggs:8881 {
          tls {
            ca https://ca.mafro.net:4433/acme/acme/directory
            ca_root /etc/step_root_ca.crt
          }

          handle_path /rtorrent/* {
            root * /media/download/rtorrent
            file_server browse
          }

          handle_path /f1/* {
            root * /media/zpool/tv/video/F1
            file_server browse
          }

          handle_path /tv/* {
            root * /media/zpool/tv/tv
            file_server browse
          }

          handle_path /x/* {
            root * /media/zpool/tv/video/_
            file_server browse
          }
        }
    - require:
      - pkg: caddy
