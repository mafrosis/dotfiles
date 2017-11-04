{% if grains['os'] == "Debian" %}
nonfree-pkgrepo:
  pkgrepo.managed:
    - humanname: Debian Non-Free
    - name: deb http://{{ pillar.get('deb_mirror_prefix', 'httpredir') }}.debian.org/debian {{ grains['oscodename'] }} non-free
    - file: /etc/apt/sources.list.d/non-free.list
{% endif %}
