base:
  '*':
    - common
    - docker
    - disable-salt-minion
    - step-cli

  'G@os:Debian':
    - common.debian

  'G@os:Ubuntu':
    - common.ubuntu

  'G@host:jorg':
    - match: compound
    - grub-timeout-0
    - jorg
    - jorg.monitoring
    - linux-util
    - linux-util.disk-tools
    - mp3
    - pools-perm-watchdog
    - rtorrent
    - rtorrent.move-torrent
    - sabnzbd
    - samba
    - usbmount
    - vpn
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
    - debian-repos.backports
    - debian-repos.contrib
    - grub-timeout-0
    - locke
    - kodi
    - linux-util
    - linux-util.disk-tools
    - mp3
    - snapclient

  'G@host:ringil':
    - match: compound
    - linux-util
    - mp3
    - mpd
    - mpd.scribble
    - snapserver

  'G@host:whirrun':
    - match: compound
    - linux-util
    - snapclient

  'G@host:caul':
    - match: compound
    - linux-util
    - snapclient
