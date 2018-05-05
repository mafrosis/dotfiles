disable-rtorrent:
  service.disabled:
    - name: rtorrent
    - order: last

disable-sabnzbd:
  service.disabled:
    - name: sabnzbd
    - order: last
