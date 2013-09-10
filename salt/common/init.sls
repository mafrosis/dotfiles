include:
  - apt

git:
  pkg.installed

required-packages:
  pkg.installed:
    - names:
      - ntp
      - language-pack-en
      - debconf-utils
      - build-essential
      - curl
      - rsync
      - axel
      - python-pip
      - bash-completion
      - zip
      - unzip
      - man
      - cryptsetup
    - require:
      - file: apt-no-recommends
