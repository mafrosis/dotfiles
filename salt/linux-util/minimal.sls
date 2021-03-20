include:
  - apt

linux-utils-pkgs:
  pkg.latest:
    - names:
      - curl
      - dnsutils
      - ethtool
      - htop
      - rsync
      - unzip
      - telnet
      - whois
    - require:
      - file: apt-no-recommends
