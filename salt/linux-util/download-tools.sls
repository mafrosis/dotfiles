{% set user = pillar.get('login_user', 'vagrant') %}


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
    - user: {{ user }}
    - unless: plowmod --status 2>&1 | grep 'modules found'
    - require:
      - cmd: plowshare-install


home-bin-dir-download-tools:
  file.directory:
    - name: /home/{{ user }}/bin
    - user: {{ user }}
    - group: {{ user }}


libmozjs-24-bin:
  pkg.installed

/usr/local/bin/js:
  file.symlink:
    - target: /usr/bin/js24
    - require:
      - pkg: libmozjs-24-bin

/opt/jsawk:
  file.directory:
    - user: {{ user }}

jsawk-git:
  git.latest:
    - name: https://github.com/micha/jsawk.git
    - rev: master
    - target: /opt/jsawk
    - user: {{ user }}
    - require:
      - pkg: git
      - file: /opt/jsawk

jsawk-install:
  file.symlink:
    - name: /home/{{ user }}/bin/jsawk
    - target: /opt/jsawk/jsawk
    - require:
      - git: jsawk-git
      - file: home-bin-dir-download-tools


/opt/Imgur:
  file.directory:
    - user: {{ user }}

imgur.sh-git:
  git.latest:
    - name: https://github.com/manabutameni/Imgur.git
    - rev: master
    - target: /opt/Imgur
    - user: {{ user }}
    - require:
      - pkg: git
      - file: /opt/Imgur

imgur.sh-install:
  file.symlink:
    - name: /home/{{ user }}/bin/imgur.sh
    - target: /opt/Imgur/imgur.sh
    - require:
      - git: imgur.sh-git
      - file: home-bin-dir-download-tools

youtube-dl:
  pip.installed:
    - upgrade: true
