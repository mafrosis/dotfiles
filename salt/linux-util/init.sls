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

debian-nonfree-pkgrepo:
  pkgrepo.managed:
    - humanname: {{ grains['oscodename'] }} Non-free
    - name: deb http://{{ pillar.get('deb_mirror_prefix', 'ftp.us') }}.debian.org/debian {{ grains['oscodename'] }} non-free
    - file: /etc/apt/sources.list.d/{{ grains['oscodename'] }}-nonfree.list
    - require_in:
      - pkg: unrar

unrar:
  pkg.installed
