include:
  - apt


linux-utils-base-pkgs:
  pkg.latest:
    - names:
      - curl
      - dnsutils
      - ethtool
      - htop
      - netcat
      - rsync
      - unzip
      - telnet
      - whois
      - zip
    - require:
      - file: apt-no-recommends
