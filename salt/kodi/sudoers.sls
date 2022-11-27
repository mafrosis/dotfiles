kodi-sudo:
  pkg.installed:
    - name: sudo

{% if pillar.get('login_user', false) %}

/etc/sudoers.d/kodi-restart:
  file.managed:
    - contents: |
        Defaults env_reset
        Defaults env_keep += "HOME"
        {{ pillar['login_user'] }}  ALL=NOPASSWD: /bin/systemctl restart kodi.service
    - mode: 0440
    - require:
      - pkg: kodi-sudo

{% endif %}
