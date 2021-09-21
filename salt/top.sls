base:
  '*':
    - common
    - common.ssh
    - docker
    - disable-salt-minion

  'G@os:Debian':
    - common.debian

  'G@os:Ubuntu':
    - common.ubuntu

  'G@id:vagrant':
    - match: compound
    - linux-util
    - linux-util.download-tools
    - mpd
    - rtorrent
    - sabnzbd

  'G@host:jorg':
    - match: compound
    - grub-timeout-0
    - jorg
    - jorg.monitoring
    - linux-util
    - linux-util.disk-tools
    - linux-util.download-tools
    - mp3
    - pools-perm-watchdog
    - rtorrent
    - rtorrent.move-torrent
    - sabnzbd
    - samba
    - usbmount
    - vpn
    - wakeonlan
    - zfs-on-linux

  'G@host:kvothe':
    - match: compound
    - linux-util
    - mp3
    - mpd
    - mpd.scribble
    - snapclient
    - snapserver
    - wifi

  'G@host:locke':
    - match: compound
    - grub-timeout-0
    - locke
    - kodi
    - linux-util
    - linux-util.disk-tools
    - linux-util.download-tools

  'G@host:ringil':
    - match: compound
    - linux-util

  'G@host:whirrun':
    - match: compound
    - linux-util
    - snapclient

  'G@host:caul':
    - match: compound
    - linux-util
    - snapclient
