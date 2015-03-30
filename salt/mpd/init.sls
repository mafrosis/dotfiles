mpd:
  pkg.installed

/etc/mpd.conf:
  file.managed:
    - source: salt://mpd/mpd.conf
    - template: jinja
    - defaults:
        bind_to_address: {{ salt['cmd.run']("hostname -I | awk '/.*/ {print $1}'") }}
