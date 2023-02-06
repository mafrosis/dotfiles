{% set user = pillar.get('login_user') %}

snapcast-build-apt-deps:
  pkg.installed:
    - names:
      - build-essential
      - alsa-utils
      - avahi-daemon
      - libasound2-dev
      - libavahi-client-dev
      - libboost1.74-all-dev
      - libexpat1-dev
      - libflac-dev
      - libopus-dev
      - libpulse-dev
      - libsoxr-dev
      - libvorbisidec-dev
      - libvorbis-dev

snapcast-build:
  git.cloned:
    - name: https://github.com/badaix/snapcast
    - branch: v0.27.0
    - target: /tmp/snapcast
    - runas: {{ user }}
  cmd.wait:
    - name: make
    - cwd: /tmp/snapcast
    - require:
      - pkg: snapcast-build-apt-deps
    - watch:
      - git: snapcast-build
