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
  service.enabled:
    - require:
      - pkg: rtorrent
      - user: rtorrent
      - file: rtorrent-download-dir
      - file: /var/cache/rtorrent/session
      - file: rtorrent.rc
      - file: rtorrent-init-script

# install init script that runs rtorrent in a tmux session
rtorrent-init-script:
  file.managed:
{% if grains.get('systemd', False) %}
    - name: /etc/systemd/system/rtorrent.service
    - source: salt://rtorrent/rtorrent.service
{% else %}
    - name: /etc/init.d/rtorrent
    - source: salt://rtorrent/rtorrent.init
{% endif %}
    - template: jinja
    - dir_mode: 744
    - defaults:
        config: /etc/rtorrent/rtorrent.rc

# ensure storrent download directory exists
rtorrent-download-dir:
  file.directory:
    - name: {{ pillar['rtorrent_download_dir'] }}
    - user: {{ pillar['login_user'] }}
    - group: rtorrent
    - dir_mode: 775
    - require:
      - user: rtorrent

# ensure rtorrent session directory exists
/var/cache/rtorrent/session:
  file.directory:
    - user: rtorrent
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
{% set user = pillar['login_user'] %}

add-rtorrent-group-to-login-user:
  user.present:
    - name: {{ user }}
    - groups:
      - rtorrent
    - remove_groups: false

/home/{{ user }}/watch:
  file.directory:
    - user: {{ user }}
    - group: {{ user }}

home-bin-rtorrent:
  file.directory:
    - name: /home/{{ user }}/bin
    - user: {{ user }}
    - group: {{ user }}
    - mode: 755

/home/{{ user }}/bin/rtorrent-attach:
  file.managed:
    - contents: |
        #! /bin/bash
        tmux -S /tmp/rtorrent.sock attach
    - user: {{ user }}
    - group: {{ user }}
    - mode: 700
    - require:
      - file: home-bin-rtorrent
{% endif %}
