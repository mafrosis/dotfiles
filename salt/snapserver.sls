{% set snap_version = "0.24.0" %}

install-snapserver:
  file.managed:
    - name: /tmp/snapserver_{{ snap_version }}-1_{{ grains["osarch"] }}.deb
    - source: https://github.com/badaix/snapcast/releases/download/v{{ snap_version }}/snapserver_{{ snap_version }}-1_{{ grains["osarch"] }}.deb
    {% if grains["osarch"] == "armhf" %}
    - source_hash: md5=5a8f9b4524c3be3cf9c4ec5a38007927
    {% else %}
    - source_hash: md5=f10fd382968393cd28ce75186500a81e
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
