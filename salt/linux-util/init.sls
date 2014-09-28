include:
  - apt

linux-utils-pkgs:
  pkg.latest:
    - names:
      - usbmount
      - hfsprogs
      - curl
      - rsync
      - zip
      - unzip
      - ncdu
      - axel
    - require:
      - file: apt-no-recommends

wheezy-nonfree-pkgrepo:
  pkgrepo.managed:
    - humanname: Wheezy Non-free
    - name: deb http://{{ pillar.get('deb_mirror_prefix', 'ftp.us') }}.debian.org/debian wheezy non-free
    - file: /etc/apt/sources.list.d/wheezy-nonfree.list
    - require_in:
      - pkg: unrar

unrar:
  pkg.installed
