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
        - file: /etc/nginx/apps.conf.d/youtube-dl.conf


create-youtube-dl-user:
  user.present:
    - name: youtube-dl
    - home: /home/youtube-dl
    - shell: /bin/bash
    - gid_from_name: true
    - remove_groups: false

/srv/youtube-dl:
  file.directory:
    - user: youtube-dl
    - group: youtube-dl
    - require:
      - user: youtube-dl

youtube-dl-source:
  git.latest:
    - name: https://github.com/mafrosis/youtube-dl.git
    - rev: master
    - target: /srv/youtube-dl
    - user: youtube-dl
    - require:
      - file: /srv/youtube-dl
      - user: youtube-dl

virtualenv-youtube-dl:
  virtualenv.managed:
    - name: /home/youtube-dl/.virtualenvs/youtube-dl
    - requirements: /srv/youtube-dl/config/requirements.txt
    - user: youtube-dl
    - system_site_packages: true
    - require:
      - git: youtube-dl-source

flask-app-config-youtube-dl:
  file.managed:
    - name: /srv/youtube-dl/flask.conf.py
    - source: salt://youtube-dl/flask.conf.py
    - template: jinja
    - user: youtube-dl
    - group: youtube-dl
    - defaults:
        secret_key: {{ pillar['flask_secret_key'] }}
        user: youtube-dl
        rabbitmq_password: {{ pillar['youtube-dl_rabbitmq_password'] }}
        rabbitmq_vhost: youtube-dl
    - require:
      - git: youtube-dl-source
        user: youtube-dl
    - require_in:
      - service: supervisor

etc-gunicorn-youtube-dl:
  file.directory:
    - mode: 655
    - name: /etc/gunicorn.d

gunicorn-config-youtube-dl:
  file.managed:
    - name: /etc/gunicorn.d/youtube-dl.conf.py
    - source: salt://youtube-dl/gunicorn.py
    - template: jinja
    - mode: 644
    - defaults:
        port: {{ pillar['youtube-dl_gunicorn_port'] }}
    - require:
      - file: etc-gunicorn-youtube-dl

/etc/supervisor/conf.d/youtube-dl.conf:
  file.managed:
    - source: salt://youtube-dl/supervisord.conf
    - template: jinja
    - defaults:
        app_user: youtube-dl
    - require:
      - user: create-youtube-dl-user
    - require_in:
      - service: supervisor

youtube-dl-supervisor-service:
  supervisord.running:
    - name: "youtube-dl:"
    - update: true
    - restart: true
    - require:
      - virtualenv: virtualenv-youtube-dl
    - watch:
      - file: /etc/supervisor/conf.d/youtube-dl.conf

# integrate with nginx_apps
/etc/nginx/apps.conf.d/youtube-dl.conf:
  file.managed:
    - source: salt://youtube-dl/nginx.conf
    - template: jinja
    - defaults:
        port: {{ pillar['youtube-dl_gunicorn_port'] }}
    - require:
      - file: /etc/nginx/apps.conf.d
    - require_in:
      - service: nginx

# setup the rabbitmq user for youtube-dl
rabbitmq-vhost-youtube-dl:
  rabbitmq_vhost.present:
    - name: youtube-dl

rabbitmq-user-youtube-dl:
  rabbitmq_user.present:
    - name: youtube-dl
    - password: "{{ pillar['youtube-dl_rabbitmq_password'] }}"
    - perms:
      - '/youtube-dl':
        - '.*'
        - '.*'
        - '.*'
    - require:
      - pkg: rabbitmq-server
      - rabbitmq_vhost: rabbitmq-vhost-youtube-dl
