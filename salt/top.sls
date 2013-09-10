base:
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
    - sysadmin
