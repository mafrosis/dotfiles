base:
  '*':
    - common
    - disable-salt-minion

  'G@id:vagrant':
    - match: compound
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

  'G@host:kvothe':
    - match: compound
    - disable-salt-minion
    - docker
    - linux-util
    - mp3
    - mpd
    - mpd.scribble
    - nginx.apps
    - wifi

  'G@host:locke':
    - match: compound
    - disable-salt-minion
    - docker
    - locke
    - kodi
    - linux-util
    - linux-util.download-tools

  'id:raspbmc':
    - match: grain
    - dev-user

  'G@host:ringil':
    - match: compound
    - disable-salt-minion
    - docker
    - linux-util
