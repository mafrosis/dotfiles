# rtorrent requires LVM to be ready, which it is not at boot
# http://unix.stackexchange.com/q/223868/8504
disable-rtorrent:
  service.disabled:
    - name: rtorrent
    - order: last
