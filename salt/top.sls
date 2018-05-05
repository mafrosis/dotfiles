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
    - dev-user
    - docker
    #- dropbox
    #- dvd-tools
    - jorg
    - linux-util
    - linux-util.download-tools
    - mp3
    - pools-perm-watchdog
    - rtorrent
    #- rtorrent.rutorrent
    - rtorrent.move-torrent
    - sabnzbd
    - samba
    #- wakeonlan
    #- xbox360
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
    - pools-perm-watchdog
    - rtorrent
    - rtorrent.move-torrent
    #- sabnzbd
    - zfs-on-linux

  'id:raspbmc':
    - match: grain
    - dev-user
