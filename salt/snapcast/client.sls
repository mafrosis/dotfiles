{% set snap_version = "0.31.0" %}

install-snapcast:
  pkg.installed:
    - sources:
      - snapclient: https://github.com/badaix/snapcast/releases/download/v{{ snap_version }}/snapclient_{{ snap_version }}-1_{{ grains["osarch"] }}_{{ grains["oscodename"] }}.deb

/etc/default/snapclient:
  file.managed:
    - contents: |
        START_SNAPCLIENT=true
        SNAPCLIENT_OPTS="--host {{ pillar["snapserver"] }} --hostID {{ grains["host"] }} -s '{{ pillar["snapclient_sound_device_id"] }}' --mixer {{ pillar.get("snapclient_mixer", "software") }}"

snapclient:
  service.running:
    - enable: true
    - restart: true
    - unmask: true
    - watch:
      - file: /etc/default/snapclient
