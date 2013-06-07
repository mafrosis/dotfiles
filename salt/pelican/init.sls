include:
  - common
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
    - name: /home/{{ grains['user'] }}/.virtualenvs/pelican/bin/sphinx-build -b html -d _build/doctrees . _build/html
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

