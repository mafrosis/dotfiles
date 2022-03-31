include:
  - debian-repos.nonfree


disable-rtorrent:
  service.disabled:
    - name: rtorrent
    - order: last

firmware-misc-nonfree:
  pkg.installed:
    - require:
      - pkgrepo: nonfree-pkgrepo
