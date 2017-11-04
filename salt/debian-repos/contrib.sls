{% if grains['os'] == "Debian" %}
contrib-pkgrepo:
  pkgrepo.managed:
    - humanname: Debian Contrib
    - name: deb http://{{ pillar.get('deb_mirror_prefix', 'httpredir') }}.debian.org/debian {{ grains['oscodename'] }} contrib
    - file: /etc/apt/sources.list.d/contrib.list
{% endif %}
