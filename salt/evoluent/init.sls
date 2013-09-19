xorg-mouse-config:
  file.managed:
    - name: /usr/share/X11/xorg.conf.d/90-evoluent.conf
    - source: salt://evoluent/90-evoluent.conf
