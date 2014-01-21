include:
  - nginx

extend:
  nginx:
    service.running:
      - require:
        - file: /etc/nginx/sites-enabled/{{ grains['host'] }}.conf
      - watch:
        - file: /etc/nginx/sites-available/{{ grains['host'] }}.conf


# create the core nginx config for this host
/etc/nginx/sites-available/{{ grains['host'] }}.conf:
  file.managed:
    - source: salt://nginx_apps/host.nginx.conf.sls
    - template: jinja
    - defaults:
        host: {{ grains['host'] }}

/etc/nginx/sites-enabled/{{ grains['host'] }}.conf:
  file.symlink:
    - target: /etc/nginx/sites-available/{{ grains['host'] }}.conf
    - require:
      - file: /etc/nginx/sites-available/{{ grains['host'] }}.conf

# create a subdirectory for other apps to install nginx config into
/etc/nginx/apps.conf.d:
  file.directory:
    - require:
      - pkg: nginx
