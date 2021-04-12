include:
  - supervisor

create-xbmcswitch-user:
  user.present:
    - name: xbmcswitch
    - home: /home/xbmcswitch
    - shell: /bin/bash
    - usergroup: true
    - remove_groups: false

/opt/xbmcswitch:
  file.directory:
    - user: xbmcswitch

xbmcswitch-source:
  git.latest:
    - name: https://github.com/mafrosis/XbmcSwitch.git
    - rev: master
    - target: /opt/xbmcswitch
    - user: xbmcswitch

virtualenv-xbmcswitch:
  virtualenv.managed:
    - name: /home/xbmcswitch/.virtualenvs/xbmcswitch
    - requirements: /opt/xbmcswitch/config/requirements.txt
    - user: xbmcswitch
    - system_site_packages: true
    - require:
      - git: xbmcswitch-source

/etc/init.d/XbmcSwitch:
  file.managed:
    - source: salt://xbmc/XbmcSwitch.init
    - template: jinja
    - defaults:
        venv: /home/xbmcswitch/.virtualenvs/xbmcswitch
        user: mafro
        xbmc_pid_path: /var/run/xbmc
    - require:
      - git: xbmcswitch-source
