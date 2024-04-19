{% set snap_version = "0.28.0" %}

install-snapcast:
  archive.extracted:
    - name: /var/cache/dotfiles/snapcast
    - source: https://github.com/badaix/snapcast/releases/download/v{{ snap_version }}/snapcast_{{ snap_version }}_{{ grains["osarch"] }}-debian-{{ grains["oscodename"] }}.zip
    {% if grains['osarch'] == 'amd64' %}
    - source_hash: md5=659eb06d9ab7008678e3476d1bc056cd
    {% elif grains['osarch'] == 'armhf' %}
    - source_hash: md5=00b9480b1603475dc131dc0dd57ec6fd
    {% elif grains['osarch'] == 'arm64' %}
    - source_hash: md5=73784084301b4233724be8ae23acde3a
    {% endif %}
    - source_hash_update: true
    - enforce_toplevel: false
  cmd.wait:
    - name: dpkg -i --force-confold /var/cache/dotfiles/snapcast/snapclient_{{ snap_version }}-1_without-pulse_{{ grains["osarch"] }}.deb
    - watch:
      - archive: install-snapcast

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
