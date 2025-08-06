sudo:
  pkg.installed


{% set user = pillar.get('login_user', 'mafro') %}

# Grant no password sudo for Pillar "login_user"
/etc/sudoers.d/{{ user }}:
  file.managed:
    - contents: |
        Defaults env_reset
        Defaults env_keep += "HOME"
        {{ user }}  ALL=(ALL)  NOPASSWD:ALL
    - mode: 0440
    - require:
      - pkg: sudo
