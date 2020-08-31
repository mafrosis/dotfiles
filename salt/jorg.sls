include:
  - debian-repos.nonfree


disable-rtorrent:
  service.disabled:
    - name: rtorrent
    - order: last

disable-sabnzbd:
  service.disabled:
    - name: sabnzbd
    - order: last

firmware-misc-nonfree:
  pkg.installed:
    - require:
      - pkgrepo: nonfree-pkgrepo
