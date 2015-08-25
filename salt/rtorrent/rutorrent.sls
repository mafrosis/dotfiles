include:
  - nginx
  - nginx_apps
  - rtorrent

extend:
  nginx:
    service.running:
      - watch:
        - file: /etc/nginx/apps.conf.d/rutorrent.conf


# install php5-cgi and create a supervisor config to control it
php5-cgi:
  pkg.installed

/etc/supervisor/conf.d/php5-cgi.conf:
  file.managed:
    - source: salt://rtorrent/php5-cgi.supervisord.conf
    - mode: 644
    - require:
      - service: supervisor
  cmd.wait:
    - name: supervisorctl update
    - watch:
      - file: /etc/supervisor/conf.d/php5-cgi.conf

# install rutorrent web-frontend
/srv/rutorrent:
  file.directory:
    - user: rtorrent
    - group: rtorrent
    - mode: 755

/tmp/rutorrent-3.6.tar.gz:
  file.managed:
    - source: http://dl.bintray.com/novik65/generic/rutorrent-3.6.tar.gz
    - source_hash: sha1=5870cddef717c83560e89aee56f2b7635ed1c90d
  cmd.wait:
    - name: tar xzf /tmp/rutorrent-3.6.tar.gz
    - onlyif: test -f /srv/rutorrent/index.html
    - user: rtorrent
    - cwd: /srv
    - require:
      - file: /srv/rutorrent
    - watch:
      - file: /tmp/rutorrent-3.6.tar.gz

# create an nginx config for rutorrent
/etc/nginx/apps.conf.d/rutorrent.conf:
  file.managed:
    - source: salt://rtorrent/rutorrent.nginx.conf
    - require:
      - file: /etc/nginx/apps.conf.d
