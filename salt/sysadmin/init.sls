include:
  - apt

required-packages-sysadmin:
  pkg.installed:
    - names:
      - disktype
      - iotop
      - htop
      - whois
      - telnet
      - curl
      - rsync
      - axel
      - zip
      - unzip
      - cryptsetup
      - lvm2
      - parted
      - dnsutils
      - smartmontools
    - require:
      - file: apt-no-recommends
