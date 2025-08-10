include:
  - samba


/etc/samba/smb.conf.d/jorg.conf:
  file.managed:
    - source: salt://samba/jorg.conf
