sudo:
  pkg.installed

{% if grains['os'] == "Debian" and pillar.get('login_user', false) %}

{% if pillar['login_user'] == "vagrant" %}

/etc/sudoers.d/vagrant:
  file.append:
    - text: "Defaults env_reset\nDefaults env_keep += \"HOME\""
    - require:
      - pkg: sudo

{% else %}

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

{% endif %}
