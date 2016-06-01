include:
  - apt
  - debian-repos.nonfree

linux-utils-pkgs:
  pkg.latest:
    - names:
      - axel
      - bmap-tools
      - cryptsetup
      - curl
      - disktype
      - dnsutils
      - hfsprogs
      - htop
      - iotop
      - lshw
      - lvm2
      - ncdu
      - parted
      - pastebinit
      - rsync
      - smartmontools
      - unzip
      - usbmount
      - telnet
      - whois
      - zip
    - require:
      - file: apt-no-recommends

unrar:
  pkg.installed:
    - require:
      - pkgrepo: nonfree-pkgrepo
