include:
  - apt


linux-utils-disk-tools-pkgs:
  pkg.latest:
    - names:
      - bmap-tools
      - cryptsetup
      - hfsprogs
      - lvm2
      - ncdu
      - parted
      - smartmontools
    - require:
      - file: apt-no-recommends
