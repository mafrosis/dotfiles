{% set snap_version = "0.26.0" %}

{% if grains["osarch"] == "arm64" %}

install-snapserver:
  file.managed:
    - name: /tmp/snapserver.tgz
    - source: https://github.com/mafrosis/snapcast/releases/download/v{{ snap_version }}/snapserver_{{ snap_version }}-1_arm64.tgz
    - source_hash: md5=04b7a62013557c24eda9ffedb682d885
  cmd.wait:
    - name: tar xzf /tmp/snapserver.tgz && mv /tmp/snapserver /usr/bin/snapserver
    - cwd: /tmp
    - watch:
      - file: install-snapserver

/etc/default/snapserver:
  file.managed:
    - source: https://github.com/badaix/snapcast/raw/v{{ snap_version }}/debian/snapserver.default
    - source_hash: md5=24e2cc57df2dd11200ba81a930f6cd2e

snapserver-user:
  user.present:
    - name: snapserver
    - system: true
    - home: /var/lib/snapserver
    - createhome: false
    - groups:
      - audio

/var/lib/snapserver:
  file.directory:
    - user: snapserver
    - group: snapserver
    - mode: 0750

extend:
  snapserver:
    file.managed:
      - name: /lib/systemd/system/snapserver.service
      - source: https://github.com/badaix/snapcast/raw/v{{ snap_version }}/debian/snapserver.service
      - source_hash: md5=7bfa869897e9cb3309ae7979356d2cd3
    service.running:
      - watch:
        - file: snapserver

{% else %}

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

{% endif %}

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
