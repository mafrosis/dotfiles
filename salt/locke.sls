# handle the hangs at poweroff
# http://serverfault.com/questions/706475/ssh-sessions-hang-on-shutdown-reboot
libpam-systemd:
  pkg.installed
