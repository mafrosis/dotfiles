include:
  - nginx_apps
  - rtorrent

{% set rtorrent_user = pillar.get('rtorrent_user', 'rtorrent') %}

extend:
  nginx:
    service.running:
      - watch:
        - file: /etc/nginx/apps.conf.d/rutorrent.conf


php-cgi:
  pkg.installed

/etc/supervisor/conf.d/php-cgi.conf:
  file.managed:
    - source: salt://rtorrent/php-cgi.supervisord.conf
    - template: jinja
    - mode: 644
    - defaults:
        user: {{ rtorrent_user }}
    - require:
      - service: supervisor
  cmd.wait:
    - name: supervisorctl update
    - watch:
      - file: /etc/supervisor/conf.d/php-cgi.conf

/tmp/rutorrent-3.8.tar.gz:
  file.managed:
    - source: https://github.com/Novik/ruTorrent/archive/v3.8.tar.gz
    - source_hash: sha1=6519ade2c5b0af40c0869f326df86daf17e6cad3
  cmd.wait:
    - name: tar xzf /tmp/rutorrent-3.8.tar.gz
    - onlyif: test -f /srv/rutorrent/index.html
    - cwd: /srv
    - watch:
      - file: /tmp/rutorrent-3.8.tar.gz

rutorrent-chmod:
  file.directory:
    - name: /srv/rutorrent
    - user: {{ rtorrent_user }}
    - group: www-data
    - dir_mode: 755
    - file_mode: 644
    - recurse:
      - user
      - group
      - mode
    - require:
      - cmd: /tmp/rutorrent-3.8.tar.gz

# create an nginx config for rutorrent
/etc/nginx/apps.conf.d/rutorrent.conf:
  file.managed:
    - source: salt://rtorrent/rutorrent.nginx.conf
    - require:
      - file: /etc/nginx/apps.conf.d
