{% set user = pillar['login_user'] %}


/home/{{ user }}/.ssh/config.d:
  file.directory:
    - makedirs: true

/home/{{ user }}/.ssh:
  file.directory:
    - dir_mode: 700
    - file_mode: 600
    - user: {{ user }}
    - group: {{ user }}
    - recurse:
      - user
      - group
      - mode

/home/{{ user }}/.ssh/config:
  file.managed:
    - contents: |
        Host *
                Compression yes
                ServerAliveInterval 600
                ControlMaster auto
                ControlPath /tmp/ssh-%r@%h:%p

        Include config.d/*
    - mode: 600
    - user: {{ user }}
    - group: {{ user }}

/home/{{ user }}/.ssh/config.d/github:
  file.managed:
    - contents: |
        Host github.com
                IdentityFile ~/.ssh/github.pky
    - mode: 600
    - user: {{ user }}
    - group: {{ user }}

/home/{{ user }}/.ssh/github.pky:
  file.managed:
    - mode: 600
    - user: {{ user }}
    - group: {{ user }}
    - replace: false
