include:
  - apt
  - debian-repos.nonfree

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

unrar:
  pkg.installed:
    - require:
      - pkgrepo: nonfree-pkgrepo
