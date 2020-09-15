{% set snap_version = "0.21.0" %}

install-snapserver:
  file.managed:
    - name: /tmp/snapserver_{{ snap_version }}-1_{{ grains["osarch"] }}.deb
    - source: https://github.com/badaix/snapcast/releases/download/v{{ snap_version }}/snapserver_{{ snap_version }}-1_{{ grains["osarch"] }}.deb
    {% if grains["osarch"] == "armhf" %}
    - source_hash: md5=a91eb0c81688e294c800dcb2dac92798
    {% else %}
    - source_hash: md5=1bae6e99da7899a3409997b81b607a80
    {% endif %}
  cmd.wait:
    - name: dpkg -i /tmp/snapserver_{{ snap_version }}-1_{{ grains["osarch"] }}.deb
    - watch:
      - file: install-snapserver
