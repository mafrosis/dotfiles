include:
  - debian.nonfree


firmware-misc-nonfree:
  pkg.installed:
    - require:
      - pkgrepo: nonfree-pkgrepo
