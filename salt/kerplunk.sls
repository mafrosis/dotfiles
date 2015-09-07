extend:
  sabnzbd-config:
    file.managed:
      - name: /home/sabnzbd/sabnzbd.ini
      - context:
          download_dir: /media/download/usenet/incomplete
          complete_dir: /media/download/usenet/complete
          dirscan_dir: /media/download/usenet/watch


# rtorrent requires LVM to be ready, which it is not at boot
# http://unix.stackexchange.com/q/223868/8504
disable-rtorrent:
  service.disabled:
    - name: rtorrent
    - order: last

disable-sabnzbd:
  service.disabled:
    - name: sabnzbd
    - order: last
