include:
  - sudo
  - supervisor

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
      - file: /var/cache/rtorrent/session
    - watch:
      - file: /etc/init.d/rtorrent
      - file: rtorrent.rc

# install init script that runs rtorrent in a tmux session
/etc/init.d/rtorrent:
  file.managed:
    - source: salt://rtorrent/rtorrent.initd
    - template: jinja
    - dir_mode: 744
    - defaults:
        config: /etc/rtorrent/rtorrent.rc

# ensure storrent download directory exists
rtorrent-download-dir:
  file.directory:
    - name: {{ pillar['rtorrent_download_dir'] }}
    - group: rtorrent
    - dir_mode: 775
    - require:
      - user: rtorrent

# ensure rtorrent session directory exists
/var/cache/rtorrent/session:
  file.directory:
    - group: rtorrent
    - dir_mode: 775
    - makedirs: true
    - recurse:
      - group
      - mode
    - require:
      - user: rtorrent

/etc/rtorrent:
  file.directory:
    - group: rtorrent
    - dir_mode: 775

# rtorrent config file
rtorrent.rc:
  file.managed:
    - name: /etc/rtorrent/rtorrent.rc
    - source: salt://rtorrent/rtorrent.rc
    - template: jinja
    - user: rtorrent
    - group: rtorrent
    - defaults:
        download_rate: 0
        upload_rate: 10
        download_dir: {{ pillar['rtorrent_download_dir'] }}
        move_torrent: false
    - require:
      - file: /etc/rtorrent

{% if pillar.get('login_user', False) %}
add-rtorrent-group-to-login-user:
  user.present:
    - name: {{ pillar['login_user'] }}
    - groups:
      - rtorrent
    - remove_groups: false
{% endif %}

/home/{{ pillar['login_user'] }}/watch:
  file.directory:
    - user: {{ pillar['login_user'] }}
    - group: {{ pillar['login_user'] }}
