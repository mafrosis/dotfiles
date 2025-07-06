sudo:
  pkg.installed


{% if pillar.get('login_user', 'mafro') %}

# Grant no password sudo for Pillar "login_user"
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
