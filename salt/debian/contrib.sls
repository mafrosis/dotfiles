{% if grains['os'] == "Debian" %}
debian-contrib:
  pkgrepo.managed:
    - humanname: Debian Contrib
    - name: deb http://{{ pillar.get('deb_mirror_prefix', 'httpredir') }}.debian.org/debian {{ grains['oscodename'] }} contrib
    - file: /etc/apt/sources.list.d/contrib.list
{% endif %}
