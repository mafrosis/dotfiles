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
        - file: /etc/nginx/apps.conf.d/inform.conf


create-inform-user:
  user.present:
    - name: inform
    - home: /home/inform
    - shell: /bin/bash
    - gid_from_name: true
    - remove_groups: false

/srv/inform:
  file.directory:
    - user: inform
    - group: inform
    - require:
      - user: inform

inform-source:
  git.latest:
    - name: https://github.com/mafrosis/inform.git
    - rev: master
    - target: /srv/inform
    - user: inform
    - require:
      - file: /srv/inform
      - user: inform

virtualenv-inform:
  virtualenv.managed:
    - name: /home/inform/.virtualenvs/inform
    - requirements: /srv/inform/config/requirements.txt
    - user: inform
    - system_site_packages: true
    - require:
      - git: inform-source

flask-app-config-inform:
  file.managed:
    - name: /srv/inform/inform/flask.conf.py
    - source: salt://inform/flask.conf.py
    - template: jinja
    - user: inform
    - group: inform
    - defaults:
        secret_key: "{{ pillar['flask_secret_key'] }}"
        user: inform
        rabbitmq_password: "{{ pillar['inform_rabbitmq_password'] }}"
        rabbitmq_vhost: inform
    - require:
      - git: inform-source
      - user: inform
    - require_in:
      - service: supervisor

etc-gunicorn-inform:
  file.directory:
    - mode: 655
    - name: /etc/gunicorn.d

gunicorn-config-inform:
  file.managed:
    - name: /etc/gunicorn.d/inform.conf.py
    - source: salt://inform/gunicorn.py
    - template: jinja
    - mode: 644
    - defaults:
        port: {{ pillar['inform_gunicorn_port'] }}
    - require:
      - file: etc-gunicorn-inform

/etc/supervisor/conf.d/inform.conf:
  file.managed:
    - source: salt://inform/supervisord.conf
    - template: jinja
    - defaults:
        app_user: inform
    - require:
      - user: create-inform-user
    - require_in:
      - service: supervisor

inform-supervisor-service:
  supervisord.running:
    - name: "inform:"
    - update: true
    - restart: true
    - require:
      - virtualenv: virtualenv-inform
    - watch:
      - file: /etc/supervisor/conf.d/inform.conf

/var/nginx/inform-passwd.basic:
  file.managed:
    - contents: "inform:{{ pillar['inform_nginx_password'] }}"
    - makedirs: true
    - require_in:
      - pkg: nginx

# integrate with nginx_apps
/etc/nginx/apps.conf.d/inform.conf:
  file.managed:
    - source: salt://inform/nginx.conf
    - template: jinja
    - defaults:
        port: {{ pillar['inform_gunicorn_port'] }}
    - require:
      - file: /etc/nginx/apps.conf.d
    - require_in:
      - service: nginx


sqlite3:
  pkg.installed

sqlalchemy-init:
  cmd.run:
    - name: /home/inform/.virtualenvs/inform/bin/python manage.py init_db
    - unless: test -f /srv/inform/inform.sqlitedb
    - cwd: /srv/inform
    - user: inform
    - require:
      - pkg: sqlite3
    - require_in:
      - supervisord: inform-supervisor-service

memcached:
  pkg.installed

# setup the rabbitmq user for inform
rabbitmq-vhost-inform:
  rabbitmq_vhost.present:
    - name: inform

rabbitmq-user-inform:
  rabbitmq_user.present:
    - name: inform
    - password: "{{ pillar['inform_rabbitmq_password'] }}"
    - perms:
      - 'inform':
        - '.*'
        - '.*'
        - '.*'
    - require:
      - pkg: rabbitmq-server
      - rabbitmq_vhost: rabbitmq-vhost-inform
