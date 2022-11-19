{% set snap_version = "0.26.0" %}

install-snapserver:
  file.managed:
    - name: /tmp/snapserver_{{ snap_version }}-1_{{ grains["osarch"] }}.deb
    - source: https://github.com/badaix/snapcast/releases/download/v{{ snap_version }}/snapserver_{{ snap_version }}-1_{{ grains["osarch"] }}.deb
    {% if grains["osarch"] == "armhf" %}
    - source_hash: md5=88be7e5b55ae7af8a4a35e76a088c7fc
    {% elif grains["osarch"] == "amd64" %}
    - source_hash: md5=42cc57c1b609677bbae907b37a3d8bbe
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
