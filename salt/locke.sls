extend:
  sabnzbd-config:
    file.managed:
      - name: /home/sabnzbd/sabnzbd.ini
      - context:
          download_dir: /media/download/usenet/incomplete
          complete_dir: /media/download/usenet/complete
          dirscan_dir: /media/download/usenet/watch


# handle the hangs at poweroff
# http://serverfault.com/questions/706475/ssh-sessions-hang-on-shutdown-reboot
libpam-systemd:
  pkg.installed

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
