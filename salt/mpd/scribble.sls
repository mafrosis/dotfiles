mpdscribble:
  pkg:
    - installed
  service.running:
    - restart: true
    - enable: true
    - watch:
      - file: /etc/mpdscribble.conf

/etc/mpdscribble.conf:
  file.managed:
    - source: salt://mpd/mpdscribble.conf
    - template: jinja
    - defaults:
        librefm_password: {{ pillar['libre_fm'] }}
