include:
  - apt
  - debian-repos.nonfree


linux-utils-pkgs:
  pkg.latest:
    - names:
      - axel
      - curl
      - disktype
      - dkms
      - dnsutils
      - ethtool
      - htop
      - iotop
      - lshw
      - man-db
      - p7zip-full
      - pastebinit
      - rsync
      - unzip
      - telnet
      - whois
      - zip
    - require:
      - file: apt-no-recommends
