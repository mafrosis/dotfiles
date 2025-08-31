{% set user = pillar.get('login_user', 'mafro') %}


mpd:
  pkg:
    - installed
  service.running:
    - restart: true
    - enable: true
    - watch:
      - file: /etc/mpd.conf
    - require:
      - file: /home/{{ user }}/music
      - file: /home/{{ user }}/playlists
      - group: mpd-group-audio

/etc/mpd.conf:
  file.managed:
    - contents: |
        music_directory     "{{ pillar.get('mp3_dir', '/home/mafro/music') }}"
        playlist_directory  "{{ pillar.get('playlist_dir', '/home/mafro/playlists') }}"
        db_file             "/var/lib/mpd/tag_cache"
        log_file            "/var/log/mpd/mpd.log"
        state_file          "/var/lib/mpd/state"
        sticker_file        "/var/lib/mpd/sticker.sql"

        user                "mpd"
        bind_to_address     "{{ grains['host'] }}"
        bind_to_address     "/run/mpd/socket"

        metadata_to_use     "artist,albumartist,album,title,track,name,genre,date,composer,performer,disc"
        follow_outside_symlinks  "no"

        zeroconf_name       "MPD ({{ grains['host'] }})"

        {% if pillar.get('alsa_device') %}
        audio_output {
          type        "alsa"
          name        "ALSA"
          device      "{{ pillar['alsa_device'] }}"
          mixer_type  "none"
        }
        {% endif %}
        audio_output {
          type        "fifo"
          name        "snapserver"
          path        "/tmp/snapfifo"
          format      "44100:16:2"
          mixer_type  "software"
        }
        audio_output {
          type        "fifo"
          name        "snapserver_hi"
          path        "/tmp/snapfifo_hi"
          format      "96000:24:2"
          mixer_type  "none"
        }

/home/{{ user }}/playlists:
  file.directory:
    - user: {{ user }}
    - group: audio

/home/{{ user }}/music:
  file.directory:
    - user: {{ user }}
    - group: audio

mpd-group-audio:
  group.present:
    - name: audio
    - addusers:
      - mpd
