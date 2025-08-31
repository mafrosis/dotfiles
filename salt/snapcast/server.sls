{% set snap_version = "0.32.3" %}

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
        source = pipe:///tmp/snapfifo?name=44k_16b&sampleformat=44100:16:2&codec=pcm
        source = pipe:///tmp/snapfifo_hi?name=96k_24b&sampleformat=96000:24:2&codec=pcm

snapserver:
  service.running:
    - enable: true
    - restart: true
    - watch:
      - file: /etc/snapserver.conf
