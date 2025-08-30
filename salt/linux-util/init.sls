include:
  - apt


linux-utils-base-pkgs:
  pkg.latest:
    - names:
      - bind9-dnsutils
      - curl
      - ethtool
      - htop
      - netcat-openbsd
      - nvme-cli
      - rsync
      - telnet
      - unzip
      - whois
      - zip
    - require:
      - file: apt-no-recommends
