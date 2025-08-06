{% set snap_version = "0.32.2" %}

install-snapcast:
  pkg.installed:
    - sources:
      - snapserver: https://github.com/badaix/snapcast/releases/download/v{{ snap_version }}/snapserver_{{ snap_version }}-1_{{ grains["osarch"] }}_{{ grains["oscodename"] }}.deb

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
