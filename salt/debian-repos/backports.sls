{% if grains['os'] == "Debian" %}
backports-pkgrepo:
  pkgrepo.managed:
    - humanname: {{ grains['oscodename'] }} Backports
    - name: deb http://{{ pillar.get('deb_mirror_prefix', 'httpredir') }}.debian.org/debian {{ grains['oscodename'] }}-backports main
    - file: /etc/apt/sources.list.d/backports.list
{% endif %}
