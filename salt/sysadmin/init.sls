include:
  - linux-util

required-packages-sysadmin:
  pkg.installed:
    - names:
      - disktype
      - iotop
      - htop
      - whois
      - telnet
      - cryptsetup
      - lvm2
      - parted
      - dnsutils
      - smartmontools
      - bmap-tools
    - require:
      - file: apt-no-recommends
