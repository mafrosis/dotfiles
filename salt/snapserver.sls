{% set snap_version = "0.20.0" %}

install-snapserver:
  file.managed:
    - name: /tmp/snapserver_{{ snap_version }}-1_{{ grains["osarch"] }}.deb
    - source: https://github.com/badaix/snapcast/releases/download/v{{ snap_version }}/snapserver_{{ snap_version }}-1_{{ grains["osarch"] }}.deb
    {% if grains["osarch"] == "armhf" %}
    - source_hash: md5=afa1562ce70371d8bf3b2a470960b88c
    {% else %}
    - source_hash: md5=332ecfb713c4933e277dfe92c8694420
    {% endif %}
  cmd.wait:
    - name: dpkg -i /tmp/snapserver_0.20.0-1_{{ grains["osarch"] }}.deb
    - watch:
      - file: install-snapserver
