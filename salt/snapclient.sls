{% set snap_version = "0.20.0" %}

install-snapclient-deps:
  pkg.installed:
    - names:
      - libavahi-client3
      - libflac8
      - libogg0
      - libopus0
      - libsoxr0
      - libvorbis0a

install-snapclient:
  file.managed:
    - name: /tmp/snapclient_{{ snap_version }}-1_{{ grains["osarch"] }}.deb
    - source: https://github.com/badaix/snapcast/releases/download/v{{ snap_version }}/snapclient_{{ snap_version }}-1_{{ grains["osarch"] }}.deb
    {% if grains["osarch"] == "armhf" %}
    - source_hash: md5=426c9ea8672214e220301703e6aadca5
    {% else %}
    - source_hash: md5=948dd8b6b83d33d0cfe0030d5fdb5893
    {% endif %}
    - if_missing: /usr/bin/snapclient
  cmd.wait:
    - name: dpkg -i /tmp/snapclient_0.20.0-1_{{ grains["osarch"] }}.deb
    - watch:
      - file: install-snapclient

/etc/default/snapclient:
  file.managed:
    - contents: |
        START_SNAPCLIENT=true
        SNAPCLIENT_OPTS="--host kvothe --hostID {{ grains["host"] }} -s {{ pillar["snapclient_sound_device_id"] }} --mixer none"
  cmd.wait:
    - name: systemctl restart snapclient
