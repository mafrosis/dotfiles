include:
  - sudo
  - supervisor

{% set user = pillar.get('login_user', 'vagrant') %}
{% set rtorrent_user = pillar.get('rtorrent_user', 'rtorrent') %}
{% set rtorrent_group = pillar.get('rtorrent_group', 'rtorrent') %}
{% set rtorrent_download_dir = pillar.get('rtorrent_download_dir', '/home/'+user+'/rtorrent') %}

# install rtorrent via apt
rtorrent:
  pkg:
    - installed
  group.present:
    - name: {{ rtorrent_group }}
  user.present:
    - name: {{ rtorrent_user }}
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
      - file: rtorrent.service

# install systemd unit that runs rtorrent in a tmux session
rtorrent.service:
  file.managed:
    - name: /etc/systemd/system/rtorrent.service
    - source: salt://rtorrent/rtorrent.service
    - template: jinja
    - dir_mode: 744
    - defaults:
        user: {{ rtorrent_user }}
        config: /etc/rtorrent/rtorrent.rc
  module.run:
    - name: service.systemctl_reload
    - onchanges:
      - file: rtorrent.service

# ensure storrent download directory exists
rtorrent-download-dir:
  file.directory:
    - name: {{ rtorrent_download_dir }}
    - user: {{ user }}
    - group: {{ rtorrent_group }}
    - dir_mode: 775
    - require:
      - user: rtorrent

# ensure rtorrent session directory exists
/var/cache/rtorrent/session:
  file.directory:
    - user: {{ rtorrent_user }}
    - group: {{ rtorrent_group }}
    - dir_mode: 775
    - makedirs: true
    - recurse:
      - group
      - mode
    - require:
      - user: rtorrent

/etc/rtorrent:
  file.directory:
    - group: {{ rtorrent_group }}
    - dir_mode: 775

rtorrent.rc:
  file.managed:
    - name: /etc/rtorrent/rtorrent.rc
    - source: salt://rtorrent/rtorrent.rc
    - template: jinja
    - group: {{ rtorrent_group }}
    - defaults:
        download_rate: 0
        upload_rate: 10
        download_dir: {{ pillar['rtorrent_download_dir'] }}
        move_torrent: false
    - require:
      - file: /etc/rtorrent

# install basic tmux config
rtorrent-tmux-conf:
  file.managed:
    - name: /etc/rtorrent/tmux.conf
    - contents: |
        # set control char to v
        set -g prefix C-v
        unbind-key C-b
        bind C-v send-prefix
        bind-key C-v last-window
    - group: {{ rtorrent_group }}
    - require:
      - file: /etc/rtorrent

{% if pillar.get('login_user', false) %}
add-rtorrent-group-to-login-user:
  user.present:
    - name: {{ user }}
    - groups:
      - {{ rtorrent_group }}
    - remove_groups: false

/home/{{ user }}/watch:
  file.directory:
    - user: {{ user }}
    - group: {{ user }}

home-bin-rtorrent:
  file.directory:
    - name: /home/{{ user }}/.local/bin
    - user: {{ user }}
    - group: {{ user }}
    - mode: 755

/home/{{ user }}/.local/bin/rtorrent-attach:
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
