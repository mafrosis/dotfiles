{% set snap_version = "0.28.0" %}

install-snapcast:
  archive.extracted:
    - name: /var/cache/dotfiles/snapcast
    - source: https://github.com/badaix/snapcast/releases/download/v{{ snap_version }}/snapcast_{{ snap_version }}_{{ grains["osarch"] }}-debian-{{ grains["oscodename"] }}.zip
    {% if grains['osarch'] == 'amd64' %}
    - source_hash: md5=659eb06d9ab7008678e3476d1bc056cd
    {% elif grains['osarch'] == 'arm64' %}
    - source_hash: md5=73784084301b4233724be8ae23acde3a
    {% endif %}
    - source_hash_update: true
    - enforce_toplevel: false
  cmd.wait:
    - name: dpkg -i --force-confold /var/cache/dotfiles/snapcast/snapserver_{{ snap_version }}-1_{{ grains["osarch"] }}.deb
    - watch:
      - archive: install-snapcast

/etc/snapserver.conf:
  file.managed:
    - contents: |
        [http]
        enabled = false
        doc_root =
        [tcp]
        enabled = true
        [stream]
        source = pipe:///tmp/snapfifo?name=default

snapserver:
  service.running:
    - enable: true
    - restart: true
    - watch:
      - file: /etc/snapserver.conf
