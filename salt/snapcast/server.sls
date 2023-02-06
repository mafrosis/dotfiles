{% set snap_version = "0.27.0" %}

install-snapserver:
  file.managed:
    - name: /tmp/snapserver_{{ snap_version }}-1_{{ grains["osarch"] }}.deb
    - source: https://github.com/badaix/snapcast/releases/download/v{{ snap_version }}/snapserver_{{ snap_version }}-1_{{ grains["osarch"] }}.deb
    {% if grains["osarch"] == "armhf" %}
    - source_hash: md5=c05a0b17b08cfa4cdcab56c46157039e
    {% elif grains["osarch"] == "amd64" %}
    - source_hash: md5=378b6f2befd13c95a24c5736692b6ebc
    {% endif %}
  cmd.wait:
    - name: dpkg -i --force-confold /tmp/snapserver_{{ snap_version }}-1_{{ grains["osarch"] }}.deb
    - watch:
      - file: install-snapserver

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
