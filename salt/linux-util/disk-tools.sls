include:
  - apt
  - debian.nonfree


linux-utils-disk-tools-pkgs:
  pkg.latest:
    - names:
      - bmap-tools
      - cryptsetup
      - exfat-fuse
      - exfat-utils
      - lvm2
      - ncdu
      - parted
      - smartmontools
    - require:
      - file: apt-no-recommends

hfsprogs:
  pkg.latest:
    - require:
      - pkgrepo: debian-nonfree
