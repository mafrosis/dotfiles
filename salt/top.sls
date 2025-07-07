base:
  '*':
    - common
    - linux-util
    - sshd
    - step.cli
    - systemd

  'G@os:Debian':
    - common.debian

  'G@os:Ubuntu':
    - common.ubuntu

  'G@host:jorg':
    - match: compound
    - caddy
    - debian.backports
    - docker
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
    - networking.wireless
    - snapcast.client

  'G@host:locke':
    - match: compound
    - autofs
    - docker
    - mpd
    - mpd.scribble
    - networking.wired
    - snapcast.server
    - yubikey

  'G@host:caul':
    - match: compound
    - networking.wireless
    - snapcast.client

  'G@host:kvothe':
    - match: compound
    - networking.wireless
    - snapcast.client

  'G@osfullname:*Raspbian* or G@productname:*Raspberry*':
    - match: compound
    - networking.wireless-power-mgmt-off
