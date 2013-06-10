include:
  - common
  - nginx
  - virtualenv-base

extend:
  virtualenv-init:
    virtualenv.manage:
      - name: /home/{{ grains['user'] }}/.virtualenvs/pelican

  virtualenv-init-pip:
    pip.installed:
      - bin_env: /home/{{ grains['user'] }}/.virtualenvs/pelican

  virtualenv-init-distribute:
    pip.installed:
      - bin_env: /home/{{ grains['user'] }}/.virtualenvs/pelican


pelican-install:
  pip.installed:
    - name: pelican
    - bin_env: /home/{{ grains['user'] }}/.virtualenvs/pelican
    - user: {{ grains['user'] }}
    - require:
      - pip: virtualenv-init-pip

sphinx-install:
  pip.installed:
    - name: Sphinx
    - bin_env: /home/{{ grains['user'] }}/.virtualenvs/pelican
    - user: {{ grains['user'] }}
    - require:
      - pip: pelican-install

base-pelican-dir:
  file.directory:
    - name: /home/{{ grains['user'] }}/dist
    - user: {{ grains['user'] }}
    - group: {{ grains['user'] }}

pelican-docs-build:
  git.latest:
    - name: git://github.com/getpelican/pelican.git
    - rev: master
    - target: /home/{{ grains['user'] }}/dist/pelican
    - runas: {{ grains['user'] }}
    - require:
      - pkg: git
      - pip: sphinx-install
      - file: base-pelican-dir
  cmd.wait:
    - name: /home/{{ grains['user'] }}/.virtualenvs/pelican/bin/sphinx-build -Q -b html -d _build/doctrees . _build/html
    - cwd: /home/{{ grains['user'] }}/dist/pelican/docs
    - user: {{ grains['user'] }}
    - watch:
      - git: pelican-docs-build


base-blog-dir:
  file.directory:
    - name: /home/{{ grains['user'] }}/src
    - user: {{ grains['user'] }}
    - group: {{ grains['user'] }}

blog-repo-clone:
  git.latest:
    - name: git://github.com/mafrosis/blog.mafro.net.git
    - rev: master
    - target: /home/{{ grains['user'] }}/src/blog.mafro.net
    - runas: {{ grains['user'] }}
    - require:
      - pkg: git
      - file: base-blog-dir
  cmd.wait:
    - name: /home/{{ grains['user'] }}/.virtualenvs/pelican/bin/pelican /home/{{ grains['user'] }}/src/blog.mafro.net/content -o /home/{{ grains['user'] }}/src/blog.mafro.net/output -s /home/{{ grains['user'] }}/src/blog.mafro.net/pelicanconf.py -q
    - cwd: /home/{{ grains['user'] }}/src/blog.mafro.net
    - user: {{ grains['user'] }}
    - require:
      - pip: pelican-install
    - watch:
      - git: blog-repo-clone

nginx-blog-config:
  file.managed:
    - name: /etc/nginx/sites-available/blog.mafro.net.conf
    - source: salt://nginx/site.tmpl.conf
    - template: jinja
    - context:
        port: 7001
        root: /home/mafro/src/blog.mafro.net/output
        index: index.html
    - require:
      - pkg: nginx

nginx-blog-symlink:
  file.symlink:
    - name: /etc/nginx/sites-enabled/blog.mafro.net.conf
    - target: /etc/nginx/sites-available/blog.mafro.net.conf
    - require:
      - file: nginx-blog-config
  service.running:
    - name: nginx
    - reload: True
    - watch:
      - file: nginx-blog-symlink
