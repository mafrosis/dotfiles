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
      - dkms
      - dnsutils
      - ethtool
      - hfsprogs
      - htop
      - iotop
      - lshw
      - lvm2
      - man-db
      - ncdu
      - parted
      - pastebinit
      - rsync
      - smartmontools
      - unzip
      - telnet
      - whois
      - zip
    - require:
      - file: apt-no-recommends

{% if grains['os'] == "Debian" %}
unrar:
  pkg.installed:
    - require:
      - pkgrepo: nonfree-pkgrepo
{% else %}
unrar:
  pkg.installed
{% endif %}
