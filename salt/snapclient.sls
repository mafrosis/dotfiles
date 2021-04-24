{% set snap_version = "0.24.0" %}

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
    - source_hash: md5=20c8660709e091f2dcabf97c8afdd2e8
    {% else %}
    - source_hash: md5=3fa93a5ea37817f536fc6fa105d2fabe
    {% endif %}
    - if_missing: /usr/bin/snapclient
  cmd.wait:
    - name: dpkg -i /tmp/snapclient_{{ snap_version }}-1_{{ grains["osarch"] }}.deb
    - watch:
      - file: install-snapclient

/etc/default/snapclient:
  file.managed:
    - contents: |
        START_SNAPCLIENT=true
        SNAPCLIENT_OPTS="--host kvothe --hostID {{ grains["host"] }} -s {{ pillar["snapclient_sound_device_id"] }} --mixer {{ pillar.get("snapclient_mixer", "software") }}"
  cmd.wait:
    - name: systemctl restart snapclient
