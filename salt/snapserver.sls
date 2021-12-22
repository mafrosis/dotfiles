{% set snap_version = "0.26.0" %}

install-snapserver:
  file.managed:
    - name: /tmp/snapserver_{{ snap_version }}-1_{{ grains["osarch"] }}.deb
    - source: https://github.com/badaix/snapcast/releases/download/v{{ snap_version }}/snapserver_{{ snap_version }}-1_{{ grains["osarch"] }}.deb
    {% if grains["osarch"] == "armhf" %}
    - source_hash: md5=0d8efecbb83c25c6ab20bc9a4843f126
    {% else %}
    - source_hash: md5=631795041a0dbf7cc5df1031d44283f5
    {% endif %}
  cmd.wait:
    - name: dpkg -i /tmp/snapserver_{{ snap_version }}-1_{{ grains["osarch"] }}.deb
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
  cmd.wait:
    - name: systemctl restart snapserver
    - watch:
      - file: /etc/snapserver.conf
