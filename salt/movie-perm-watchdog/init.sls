include:
  - supervisor

movie-perm-watchdog:
  pip.installed:
    - name: watchdog

watchdog-service:
  supervisord.running:
    - name: "movie-perm-watchdog"
    - update: true
    - require:
      - service: supervisor
      - pip: movie-perm-watchdog
      - file: movie-perm-watchdog-supervisor-config

movie-perm-watchdog-supervisor-config:
  file.managed:
    - name: /etc/supervisor/conf.d/movie-perm-watchdog.conf
    - source: salt://movie-perm-watchdog/supervisord.conf
    - template: jinja
    - require:
      - pip: movie-perm-watchdog
    - require_in:
      - service: supervisor
