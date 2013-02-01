include:
  - apt

required-packages:
  pkg.installed:
    - names:
      - ntp
      - language-pack-en
      - debconf-utils
      - build-essential
      - curl
      - rsync
      - python-pip
      - bash-completion
    - require:
      - file: apt-no-recommends
