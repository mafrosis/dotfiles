include:
  - apt

git:
  pkg.installed

python-pip:
  pkg.installed

virtualenvwrapper:
  pip.installed:
    - require:
      - pkg: python-pip

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
      - bash-completion
      - zip
      - unzip
      - man
      - cryptsetup
    - require:
      - file: apt-no-recommends
