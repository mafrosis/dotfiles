include:
  - apt
  - debian-repos.nonfree


linux-utils-disk-tools-pkgs:
  pkg.latest:
    - names:
      - bmap-tools
      - cryptsetup
      - lvm2
      - ncdu
      - parted
      - smartmontools
    - require:
      - file: apt-no-recommends

hfsprogs:
  pkg.latest:
    - require:
      - pkgrepo: nonfree-pkgrepo
