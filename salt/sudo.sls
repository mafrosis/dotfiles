sudo:
  pkg.installed

{% if grains['os'] == "Debian" and pillar.get('login_user', false) %}

/etc/sudoers.d/{{ pillar['login_user'] }}:
  file.managed:
    - contents: |
        Defaults env_reset
        Defaults env_keep += "HOME"
        {{ pillar['login_user'] }}  ALL=(ALL)  NOPASSWD:ALL
    - mode: 0440
    - require:
      - pkg: sudo

{% endif %}
