{% set snap_version = "0.27.0" %}

install-snapclient-deps:
  pkg.installed:
    - names:
      - libasound2
      - libavahi-client3
      - libflac8
      - libogg0
      - libopus0
      - libpulse0
      - libsoxr0
      - libvorbis0a

{% if grains["osarch"] == "arm64" %}

install-snapclient:
  file.managed:
    - name: /tmp/snapclient.tgz
    - source: https://github.com/mafrosis/snapcast/releases/download/v{{ snap_version }}/snapclient_{{ snap_version }}-1_arm64.tgz
    - source_hash: md5=8c1608e5532fd0d7b454ada187c85b4e
  cmd.wait:
    - name: tar xzf /tmp/snapclient.tgz && mv /tmp/snapclient /usr/bin/snapclient
    - cwd: /tmp
    - watch:
      - file: install-snapclient

snapclient-user:
  user.present:
    - name: snapclient
    - system: true
    - home: /var/lib/snapclient
    - createhome: false
    - groups:
      - audio

/var/lib/snapclient:
  file.directory:
    - user: snapclient
    - group: snapclient
    - mode: 0750

extend:
  snapclient:
    file.managed:
      - name: /lib/systemd/system/snapclient.service
      - source: https://github.com/badaix/snapos/raw/v{{ snap_version }}/debian/snapclient.service
      - source_hash: md5=be19554e8811e696391ec0826fbec02f
    service.running:
      - watch:
        - file: snapclient

{% else %}

install-snapclient:
  file.managed:
    - name: /var/cache/dotfiles/snapclient.deb
    - source: https://github.com/badaix/snapcast/releases/download/v{{ snap_version }}/snapclient_{{ snap_version }}-1_without-pulse_{{ grains["osarch"] }}.deb
    {% if grains["osarch"] == "armhf" %}
    - source_hash: md5=45e7a6d5aeeaa45c0bd2dc080d326a8b
    {% elif grains["osarch"] == "amd64" %}
    - source_hash: md5=776dc542a268051d93f5409ea4923f0d
    {% endif %}
    - source_hash_update: true
    - if_missing: /usr/bin/snapclient
  cmd.wait:
    - name: dpkg -i --force-confold /var/cache/dotfiles/snapclient.deb
    - watch:
      - file: install-snapclient

{% endif %}

/etc/default/snapclient:
  file.managed:
    - contents: |
        START_SNAPCLIENT=true
        SNAPCLIENT_OPTS="--host {{ pillar["snapserver"] }} --hostID {{ grains["host"] }} -s '{{ pillar["snapclient_sound_device_id"] }}' --mixer {{ pillar.get("snapclient_mixer", "software") }}"

snapclient:
  service.running:
    - enable: true
    - restart: true
    - unmask: true
    - watch:
      - file: /etc/default/snapclient
