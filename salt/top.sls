base:
  '*':
    - common
    - disable-salt-minion

  'G@id:vagrant':
    - match: compound
    - user
    - disable-salt-minion
    - docker
    - linux-util
    - linux-util.download-tools
    - mpd
    - rtorrent
    - sabnzbd

  'G@host:jorg':
    - match: compound
    - disable-salt-minion
    - docker
    - jorg
    - linux-util
    - linux-util.download-tools
    - mp3
    - pools-perm-watchdog
    - rtorrent
    - rtorrent.move-torrent
    - sabnzbd
    - samba
    - wakeonlan
    - zfs-on-linux

  'G@host:locke':
    - match: compound
    - user
    - disable-salt-minion
    - docker
    - locke
    - kodi
    - mp3
    - mp3.beets
    - mpd
    - mpd.scribble
    - linux-util
    - linux-util.download-tools

  'id:raspbmc':
    - match: grain
    - dev-user
