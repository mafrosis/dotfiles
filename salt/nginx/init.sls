nginx:
  pkg:
    - installed
  service.running:
    - enable: true
    - require:
      - pkg: nginx
      - file: /etc/nginx/sites-enabled/default
    - watch:
      - file: /etc/nginx/conf.d/http.conf
      - file: /etc/nginx/conf.d/proxy.conf

/etc/nginx/conf.d/http.conf:
  file.managed:
    - source: salt://nginx/http.conf
    - require:
      - pkg: nginx

/etc/nginx/conf.d/proxy.conf:
  file.managed:
    - source: salt://nginx/proxy.conf
    - require:
      - pkg: nginx

/etc/nginx/sites-enabled/default:
  file:
    - absent
