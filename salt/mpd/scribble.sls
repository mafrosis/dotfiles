mpdscribble:
  pkg.installed

/etc/mpdscribble.conf:
  file.managed:
    - source: salt://mpd/mpdscribble.conf
    - template: jinja
    - defaults:
        librefm_password: {{ pillar['librefm_password'] }}
