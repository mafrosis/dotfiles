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
    - disable-salt-minion
    - docker
    - firmware-realtek
    - informa
    - kerplunk
    - kodi
    - mp3
    - mp3.beets
    - mpd
    - mpd.scribble
    - linux-util
    - linux-util.download-tools
    - pools-perm-watchdog
    - rtorrent
    - rtorrent.rutorrent
    - rtorrent.move-torrent
    - sabnzbd
    - sysadmin
    - tmux-segments
    - zfs-on-linux

  'id:raspbmc':
    - match: grain
    - dev-user
