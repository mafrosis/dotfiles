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
      - debconf-utils
      - build-essential
      - bash-completion
      - man
      {% if grains['os'] == 'Ubuntu' %}
      - language-pack-en
      {% endif %}
    - require:
      - file: apt-no-recommends
