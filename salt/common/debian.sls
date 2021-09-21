include:
  - apt


required-packages:
  pkg.latest:
    - names:
      - apt-transport-https
      - coreutils
      - debconf-utils
      - libffi-dev
      - libssl-dev
      - man-db
      - software-properties-common
      - swig
    - require:
      - file: apt-no-recommends


{% if pillar.get('timezone', false) %}
{% if grains.get('systemd', false) %}
dbus:
  pkg.installed:
    - require_in:
      - timezone: {{ pillar['timezone'] }}
{% endif %}
{% endif %}
