base:
  '*':
    - common

  'id:vagrant':
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

  'host:mousetrap':
    - match: grain
    - dev-user
    - sysadmin

  'host:monopoly':
    - match: grain
    - dev-user
    - dropbox
    - linux-util
    - samba
    - sysadmin
    - xbox360
    - zfs-on-linux

  'id:raspbmc':
    - match: grain
    - dev-user
