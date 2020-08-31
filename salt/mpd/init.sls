include:
  - nginx.apps

extend:
  nginx:
    service.running:
      - watch:
        - file: /etc/nginx/apps.conf.d/mpd.conf


mpd:
  pkg.installed

/etc/mpd.conf:
  file.managed:
    - source: salt://mpd/mpd.conf
    - template: jinja
    - defaults:
        user: {{ pillar['login_user'] }}
        bind_to_address: {{ salt['cmd.shell']("hostname -I | awk '/.*/ {print $1}'") }}
        alsa_device: {{ pillar['alsa_device'] }}

/home/{{ pillar['login_user'] }}/playlists:
  file.directory:
    - user: {{ pillar['login_user'] }}
    - group: {{ pillar['login_user'] }}

# create an nginx config for album art
/etc/nginx/apps.conf.d/mpd.conf:
  file.managed:
    - source: salt://mpd/mpd.nginx.conf
    - require:
      - file: /etc/nginx/apps.conf.d

# allow nginx www-data user to read audio files (album art)
audio:
  group.present:
    - addusers:
      - www-data
