include:
  - debian.nonfree


firmware-misc-nonfree:
  pkg.installed:
    - require:
      - pkgrepo: debian-nonfree
