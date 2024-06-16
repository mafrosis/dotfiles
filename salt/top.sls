base:
  '*':
    - common
    - docker
    - linux-util
    - sshd
    - step.cli

  'G@os:Debian':
    - common.debian

  'G@os:Ubuntu':
    - common.ubuntu

  'G@host:jorg':
    - match: compound
    - grub-timeout-0
    - jorg
    - jorg.monitoring
    - linux-util.disk-tools
    - mp3
    - networking.wired
    - rtorrent
    - rtorrent.move-torrent
    - sabnzbd
    - samba
    - vpn
    - zfs-on-linux

  'G@host:ringil':
    - match: compound
    - kodi
    - networking.wireless
    - snapcast.client

  'G@host:locke':
    - match: compound
    - mp3
    - mpd
    - mpd.scribble
    - networking.wired
    - snapcast.server
    - yubikey

  'G@host:whirrun':
    - match: compound
    - networking.wireless
    - snapcast.client

  'G@host:caul':
    - match: compound
    - networking.wireless
    - snapcast.client

  'G@host:rand':
    - match: compound
    - networking.wireless

  'G@host:kvothe':
    - match: compound
    - networking.wireless
    - snapcast.client
