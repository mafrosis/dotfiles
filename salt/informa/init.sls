include:
  - nginx
  - nginx_apps
  - rabbitmq
  - supervisor
  - virtualenv

extend:
  nginx:
    service.running:
      - watch:
        - file: /etc/nginx/apps.conf.d/informa.conf


create-informa-user:
  user.present:
    - name: informa
    - home: /home/informa
    - shell: /bin/bash
    - gid_from_name: true
    - remove_groups: false

/srv/informa:
  file.directory:
    - user: informa
    - group: informa
    - require:
      - user: informa

informa-source:
  git.latest:
    - name: https://github.com/mafrosis/informa.git
    - rev: master
    - target: /srv/informa
    - user: informa
    - require:
      - file: /srv/informa
      - user: informa

virtualenv-informa:
  virtualenv.managed:
    - name: /home/informa/.virtualenvs/informa
    - requirements: /srv/informa/config/requirements.txt
    - user: informa
    - system_site_packages: true
    - require:
      - git: informa-source

flask-app-config-informa:
  file.managed:
    - name: /srv/informa/inform/flask.conf.py
    - source: salt://informa/flask.conf.py
    - template: jinja
    - user: informa
    - group: informa
    - defaults:
        secret_key: "{{ pillar['flask_secret_key'] }}"
        user: informa
        rabbitmq_password: "{{ pillar['informa_rabbitmq_password'] }}"
        rabbitmq_vhost: informa
    - require:
      - git: informa-source
      - user: informa
    - require_in:
      - service: supervisor

etc-gunicorn-informa:
  file.directory:
    - mode: 655
    - name: /etc/gunicorn.d

gunicorn-config-informa:
  file.managed:
    - name: /etc/gunicorn.d/informa.conf.py
    - source: salt://informa/gunicorn.py
    - template: jinja
    - mode: 644
    - defaults:
        port: {{ pillar['informa_gunicorn_port'] }}
    - require:
      - file: etc-gunicorn-informa

/etc/supervisor/conf.d/informa.conf:
  file.managed:
    - source: salt://informa/supervisord.conf
    - template: jinja
    - defaults:
        app_user: informa
    - require:
      - user: create-informa-user
    - require_in:
      - service: supervisor

informa-supervisor-service:
  supervisord.running:
    - name: "informa:"
    - update: true
    - restart: true
    - require:
      - virtualenv: virtualenv-informa
    - watch:
      - file: /etc/supervisor/conf.d/informa.conf

/var/nginx/informa-passwd.basic:
  file.managed:
    - contents: "informa:{{ pillar['informa_nginx_password'] }}"
    - makedirs: true
    - require_in:
      - pkg: nginx

# integrate with nginx_apps
/etc/nginx/apps.conf.d/informa.conf:
  file.managed:
    - source: salt://informa/nginx.conf
    - template: jinja
    - defaults:
        port: {{ pillar['informa_gunicorn_port'] }}
    - require:
      - file: /etc/nginx/apps.conf.d
    - require_in:
      - service: nginx


sqlite3:
  pkg.installed

sqlalchemy-init:
  cmd.run:
    - name: /home/informa/.virtualenvs/informa/bin/python manage.py init_db
    - unless: test -f /srv/informa/informa.sqlitedb
    - cwd: /srv/informa
    - runas: informa
    - require:
      - pkg: sqlite3
    - require_in:
      - supervisord: informa-supervisor-service

memcached:
  pkg.installed

# setup the rabbitmq user for informa
rabbitmq-vhost-informa:
  rabbitmq_vhost.present:
    - name: informa

rabbitmq-user-informa:
  rabbitmq_user.present:
    - name: informa
    - password: "{{ pillar['informa_rabbitmq_password'] }}"
    - perms:
      - 'informa':
        - '.*'
        - '.*'
        - '.*'
    - require:
      - pkg: rabbitmq-server
      - rabbitmq_vhost: rabbitmq-vhost-informa
