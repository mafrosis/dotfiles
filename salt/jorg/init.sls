include:
  - debian-repos.nonfree


firmware-misc-nonfree:
  pkg.installed:
    - require:
      - pkgrepo: nonfree-pkgrepo
