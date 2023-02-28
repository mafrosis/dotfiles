{% set user = pillar['login_user'] %}

mp3-pkgs:
  pkg.installed:
    - names:
      - alsa-utils
      - flac
      - lame
      - opus

/home/{{ user }}/.local/bin:
  file.directory:
    - user: {{ user }}
    - group: {{ user }}
    - mode: 755

/home/{{ user }}/.local/bin/flac-to-mp3.sh:
  file.managed:
    - source: salt://mp3/flac-to-mp3.sh
    - user: {{ user }}
    - group: {{ user }}
    - mode: 744

/home/{{ user }}/.local/bin/sync-music.sh:
  file.managed:
    - source: salt://mp3/sync-music.sh
    - user: {{ user }}
    - group: {{ user }}
    - mode: 744
