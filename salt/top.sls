base:
  '*':
    - common

  'G@host:monopoly or G@id:monopoly':
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
    - sysadmin
    - tmux-segments
    - wakeonlan
    - xbox360
    - zfs-on-linux

  'G@host:kerplunk or G@id:kerplunk':
    - match: compound
    - dev-user
    - inform
    - mpd
    - mpd.scribble
    - linux-util
    - linux-util.download-tools
    - rtorrent
    - sysadmin

  'id:raspbmc':
    - match: grain
    - dev-user
