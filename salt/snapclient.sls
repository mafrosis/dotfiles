{% set snap_version = "0.26.0" %}

install-snapclient-deps:
  pkg.installed:
    - names:
      - libavahi-client3
      - libflac8
      - libogg0
      - libopus0
      - libsoxr0
      - libvorbis0a
      - libvorbisidec1

install-snapclient:
  file.managed:
    - name: /var/cache/dotfiles/snapclient.deb
    - source: https://github.com/badaix/snapcast/releases/download/v{{ snap_version }}/snapclient_{{ snap_version }}-1_without-pulse_{{ grains["osarch"] }}.deb
    {% if grains["osarch"] == "armhf" %}
    - source_hash: md5=a54ca00097a30bf5e79b016fe423fc6d
    {% else %}
    - source_hash: md5=8525f197428a82aa06b618502e2f71cf
    {% endif %}
    - source_hash_update: true
    - if_missing: /usr/bin/snapclient
  cmd.wait:
    - name: dpkg -i /var/cache/dotfiles/snapclient.deb
    - watch:
      - file: install-snapclient

/etc/default/snapclient:
  file.managed:
    - contents: |
        START_SNAPCLIENT=true
        SNAPCLIENT_OPTS="--host {{ pillar["snapserver"] }} --hostID {{ grains["host"] }} -s {{ pillar["snapclient_sound_device_id"] }} --mixer {{ pillar.get("snapclient_mixer", "software") }}"
  cmd.wait:
    - name: systemctl restart snapclient
    - watch:
      - file: /etc/default/snapclient
