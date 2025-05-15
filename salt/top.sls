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
    - caddy
    - debian.backports
    - grub-timeout-0
    - jorg
    - jorg.caddy
    - jorg.monitoring
    - linux-util.disk-tools
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
    - autofs
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
