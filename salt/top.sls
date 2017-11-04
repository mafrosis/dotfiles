base:
  '*':
    - common

  'G@id:vagrant':
    - match: compound
    - dev-user
    - disable-salt-minion
    - docker
    - linux-util
    - linux-util.download-tools
    - mpd
    - rtorrent
    - sabnzbd

  'G@host:monopoly':
    - match: compound
    - dev-user
    - dropbox
    - dvd-tools
    - linux-util
    - mp3
    - pools-perm-watchdog
    - rtorrent
    - rtorrent.rutorrent
    - rtorrent.move-torrent
    - samba
    - wakeonlan
    - xbox360
    - zfs-on-linux

  'G@host:locke':
    - match: compound
    - dev-user
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
    - pools-perm-watchdog
    - rtorrent
    - rtorrent.move-torrent
    #- sabnzbd
    - zfs-on-linux

  'id:raspbmc':
    - match: grain
    - dev-user
