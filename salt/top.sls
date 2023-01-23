base:
  '*':
    - common
    - docker
    - sshd
    - step-cli
    - networking

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

  'G@host:ringil':
    - match: compound
    - kodi
    - linux-util
    - networking.wireless
    - snapcast.client

  'G@host:locke':
    - match: compound
    - linux-util
    - mp3
    - mpd
    - mpd.scribble
    - snapserver
    - yubikey

  'G@host:whirrun':
    - match: compound
    - linux-util
    - networking.wireless
    - snapclient

  'G@host:caul':
    - match: compound
    - linux-util
    - networking.wireless
    - snapclient

  'G@host:rand':
    - match: compound
    - linux-util
    - networking.wireless
