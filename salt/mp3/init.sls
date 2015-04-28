include:
  - mp3.cdparanoia

{% set user = pillar.get('login_user', 'vagrant') %}

lame:
  pkg.installed

flac:
  pkg.installed

/home/{{ user }}/bin:
  file.directory:
    - user: {{ user }}
    - group: {{ user }}
    - mode: 755

/home/{{ user }}/bin/flac-to-mp3.sh:
  file.managed:
    - source: salt://mp3/flac-to-mp3.sh
    - user: {{ user }}
    - group: {{ user }}
    - mode: 744

/home/{{ user }}/bin/sync-music.sh:
  file.managed:
    - source: salt://mp3/sync-music.sh
    - user: {{ user }}
    - group: {{ user }}
    - mode: 744


eyeD3:
  pip.installed

/home/{{ user }}/.eyeD3/plugins:
  file.directory:
    - user: {{ user }}
    - group: {{ user }}

/home/{{ user }}/.eyeD3/plugins/autotag.py:
  file.symlink:
    - target: /home/{{ user }}/dotfiles/salt/mp3/autotag.eyeD3plugin.py
