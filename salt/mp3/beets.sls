include:
  - virtualenv

{% set user = pillar['login_user'] %}

libchromaprint0:
  pkg.installed

/tmp/beets-reqs.txt:
  file.managed:
    - contents: |
        beets
        discogs-client
        jellyfish
        pyacoustid
        python-mpd
        requests

beets-virtualenv:
  virtualenv.managed:
    - name: /home/{{ user }}/.virtualenvs/beets
    - requirements: /tmp/beets-reqs.txt
    - user: {{ user }}
    - require:
      - pip: virtualenv
      - file: /tmp/beets-reqs.txt

/home/{{ user }}/.config/beets:
  file.directory:
    - user: {{ user }}
    - group: {{ user }}
    - makedirs: true

/home/{{ user }}/.config/beets/config.yaml:
  file.managed:
    - source: salt://mp3/beets.config.yaml
    - template: jinja
    - defaults:
        acousticid_api_key: {{ pillar['acousticid_api_key'] }}

/var/log/beets:
  file.directory:
    - user: {{ user }}
