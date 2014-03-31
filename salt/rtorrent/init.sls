include:
  - nginx
  - nginx_apps
  - sudo
  - supervisor

extend:
  nginx:
    service.running:
      - watch:
        - file: /etc/nginx/apps.conf.d/rutorrent.conf


# install rtorrent via apt
rtorrent:
  pkg:
    - installed
  group:
    - present
  user.present:
    - gid_from_name: true
    - groups:
      - video
    - remove_groups: false
    - require:
      - group: rtorrent
  service.running:
    - enable: true
    - require:
      - pkg: rtorrent
      - user: rtorrent
      - file: rtorrent-download-dir
      - file: /home/rtorrent/session
    - watch:
      - file: /etc/init.d/rtorrent
      - file: rtorrent.rc

# install init script that runs rtorrent in a tmux session
/etc/init.d/rtorrent:
  file.managed:
    - source: salt://rtorrent/rtorrent.init.sls
    - mode: 744

# ensure storrent download directory exists
rtorrent-download-dir:
  file.directory:
    - name: {{ pillar['rtorrent_download_dir'] }}
    - group: rtorrent
    - mode: 775
    - require:
      - user: rtorrent

# ensure rtorrent session directory exists
/home/rtorrent/session:
  file.directory:
    - user: rtorrent
    - group: rtorrent
    - mode: 775
    - require:
      - user: rtorrent

# rtorrent config file
rtorrent.rc:
  file.managed:
    - name: /home/rtorrent/.rtorrent.rc
    - source: salt://rtorrent/rtorrent.rc.sls
    - template: jinja
    - user: rtorrent
    - group: rtorrent
    - defaults:
        download_rate: 0
        upload_rate: 10
        download_dir: {{ pillar['rtorrent_download_dir'] }}

{% if pillar.get('login_user', False) %}
add-rtorrent-group-to-login-user:
  user.present:
    - name: {{ pillar['login_user'] }}
    - groups:
      - rtorrent
    - remove_groups: false
{% endif %}

# install php5-cgi and create a supervisor config to control it
spawn-fcgi:
  pkg.installed

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
    - unless: test -f /srv/rutorrent/index.html
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

/home/rtorrent/bin/move-torrent.sh:
  file.managed:
    - source: salt://rtorrent/move-torrent.sh
    - user: rtorrent
    - group: rtorrent
    - mode: 774

/home/{{ pillar['login_user'] }}/bin/move-torrent.sh:
  file.symlink:
    - target: /home/rtorrent/bin/move-torrent.sh

/var/log/move-torrent.log:
  file.managed:
    - user: rtorrent
    - group: rtorrent
    - mode: 550

/etc/sudoers.d/rtorrent:
  file.managed:
    - contents: "rtorrent\tALL=(ALL)\tNOPASSWD: /bin/chown\n"
    - mode: 0440
    - require:
      - pkg: sudo
