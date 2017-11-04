supervisor-dependencies:
  pkg.installed:
    - name: python-pip

supervisor-install:
  pip.installed:
    - name: supervisor
    - require:
      - pkg: supervisor-dependencies

supervisor-config-dir:
  file.directory:
    - name: /etc/supervisor/conf.d
    - makedirs: true
    - mode: 755

supervisor-config:
  file.managed:
    - name: /etc/supervisord.conf
    - source: salt://supervisor/supervisord.deb.conf
    - template: jinja
    - defaults:
        socket_mode: "0300"

supervisor-log-dir:
  file.directory:
    - name: /var/log/supervisor
    - user: root

supervisor-init-script:
  file.managed:
{% if grains.get('virtual_subtype', '') == 'Docker' or grains.get('systemd', false) == false %}
    - name: /etc/init.d/supervisor
    - source: salt://supervisor/supervisor.init
    - mode: 744
{% else %}
    - name: /etc/systemd/system/supervisor.service
    - source: salt://supervisor/supervisor.service
{% endif %}
    - user: root

supervisor:
  service.running:
    - enable: true
    - require:
      - pip: supervisor-install
    - watch:
      - file: supervisor-config
      - file: supervisor-log-dir
      - file: supervisor-init-script
