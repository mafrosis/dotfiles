include:
  - common

d3lib:
  file.managed:
    - name: /home/{{ grains['user'] }}/dist/d3.v3.zip
    - source: http://d3js.org/d3.v3.zip
    - source_hash: sha1=ace402853b6dc678fda1408500f01b33b7bf969a
    - user: {{ grains['user'] }}
    - group: {{ grains['user'] }}


wget:
  pkg:
    - installed

dashingd3js-source:
  cmd.run:
    - name: echo $(wget -q -mk www.dashingd3js.com)
    - unless: ls www.dashingd3js.com/index.html
    - cwd: /home/{{ grains['user'] }}/dist
    - user: {{ grains['user'] }}
    - require:
      - pkg: wget

nginx-dashingd3js-config:
  file.managed:
    - name: /etc/nginx/sites-available/dashingd3js.conf
    - source: salt://nginx/site.tmpl.conf
    - template: jinja
    - context:
        port: 7002
        root: /home/mafro/dist/www.dashingd3js.com
        index: index.html
    - require:
      - pkg: nginx
      - cmd: dashingd3js-source

nginx-dashingd3js-symlink:
  file.symlink:
    - name: /etc/nginx/sites-enabled/dashingd3js.conf
    - target: /etc/nginx/sites-available/dashingd3js.conf
    - require:
      - file: nginx-dashingd3js-config
  service.running:
    - name: nginx
    - reload: True
    - watch:
      - file: nginx-dashingd3js-symlink


bostocksorg-source:
  cmd.run:
    - name: echo $(wget -q -mk bost.ocks.org)
    - unless: ls bost.ocks.org/index.html
    - cwd: /home/{{ grains['user'] }}/dist
    - user: {{ grains['user'] }}
    - require:
      - pkg: wget

bostocksorg-stylesheet:
  file.symlink:
    - name: /home/{{ grains['user'] }}/dist/bost.ocks.org/mike/style.css
    - target: /home/{{ grains['user'] }}/dist/bost.ocks.org/mike/style.css?20120427
    - require:
      - cmd: bostocksorg-source

nginx-bostocksorg-config:
  file.managed:
    - name: /etc/nginx/sites-available/bostocksorg.conf
    - source: salt://nginx/site.tmpl.conf
    - template: jinja
    - context:
        port: 7003
        root: /home/mafro/dist/bost.ocks.org
        index: index.html
    - require:
      - pkg: nginx
      - cmd: bostocksorg-source

nginx-bostocksorg-symlink:
  file.symlink:
    - name: /etc/nginx/sites-enabled/bostocksorg.conf
    - target: /etc/nginx/sites-available/bostocksorg.conf
    - require:
      - file: nginx-bostocksorg-config
  service.running:
    - name: nginx
    - reload: True
    - watch:
      - file: nginx-bostocksorg-symlink
