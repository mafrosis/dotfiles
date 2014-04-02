include:
  - supervisor

pools-watchdog:
  pip.installed:
    - name: watchdog

{% for pool_name in ('video', 'music') %}

{{ pool_name }}-watchdog-service:
  supervisord.running:
    - name: "{{ pool_name }}-perm-watchdog"
    - update: true
    - require:
      - service: supervisor
      - pip: pools-watchdog
      - file: {{ pool_name }}-perm-watchdog-supervisor-config

{{ pool_name }}-perm-watchdog-supervisor-config:
  file.managed:
    - name: /etc/supervisor/conf.d/{{ pool_name }}-perm-watchdog.conf
    - source: salt://pools-perm-watchdog/supervisord.{{ pool_name }}.conf
    - template: jinja
    - require:
      - pip: pools-watchdog
    - require_in:
      - service: supervisor

{% endfor %}
