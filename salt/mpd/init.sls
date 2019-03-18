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
