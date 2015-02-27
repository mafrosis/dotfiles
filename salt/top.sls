base:
  '*':
    - common

  # default Vagrant host for testing
  'vmware:true':
    - match: grain
    - dev-user
    - sysadmin

  'role:chromebook':
    - match: grain
    - nginx
    - pelican
    - d3
    - imap
    - go

  'host:monopoly':
    - match: grain
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
    - sysadmin
    - tmux-segments
    - wakeonlan
    - xbox360
    - zfs-on-linux

  'id:raspbmc':
    - match: grain
    - dev-user
