{% set user = pillar['login_user'] %}


/opt/plowshare:
  file.directory:
    - user: {{ user }}

plowshare-git:
  git.latest:
    - name: https://github.com/mcrapet/plowshare.git
    - rev: master
    - target: /opt/plowshare
    - user: {{ user }}
    - require:
      - pkg: git
      - file: /opt/plowshare

plowshare-install:
  cmd.run:
    - name: make install
    - cwd: /opt/plowshare
    - unless: which plowdown
    - require:
      - git: plowshare-git

plowmod-install:
  cmd.run:
    - name: plowmod --install
    - cwd: /opt/plowshare
    - runas: {{ user }}
    - unless: plowmod --status 2>&1 | grep 'modules found'
    - require:
      - cmd: plowshare-install

youtube-dl:
  pip.installed:
    - upgrade: true
