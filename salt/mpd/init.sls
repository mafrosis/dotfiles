mpd:
  pkg.installed

/etc/mpd.conf:
  file.managed:
    - contents: |
        music_directory     "{{ pillar.get('mp3_dir', '/home/pi/mp3') }}"
        playlist_directory  "{{ pillar.get('playlist_dir', '/home/pi/playlists') }}"
        db_file             "/var/lib/mpd/tag_cache"
        log_file            "/var/log/mpd/mpd.log"
        pid_file            "/run/mpd/pid"
        state_file          "/var/lib/mpd/state"
        sticker_file        "/var/lib/mpd/sticker.sql"

        user                "mpd"
        bind_to_address     "{{ grains['ipv4'][1] }}"
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
          format      "48000:16:2"
          mixer_type  "software"
        }
  cmd.wait:
    - name: systemctl restart mpd
    - watch:
      - file: /etc/mpd.conf


/home/{{ pillar['login_user'] }}/playlists:
  file.directory:
    - user: {{ pillar['login_user'] }}
    - group: audio
