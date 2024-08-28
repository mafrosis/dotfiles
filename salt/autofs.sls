cifs-utils:
  pkg.installed

cifs:
  group.present

/etc/autofs:
  file.directory

autofs:
  pkg:
    - installed
  service.running:
    - restart: true
    - watch:
      - file: /etc/auto.master.d/jorg.autofs
      - file: /etc/autofs/jorg


/media/jorg:
  file.directory:
    - user: mafro
    - group: cifs
    - dir_mode: 750

/etc/auto.master.d/jorg.autofs:
  file.managed:
    - contents: |
        /media/jorg /etc/autofs/jorg --timeout 60 --browse

/etc/autofs/jorg:
  file.managed:
    - contents: |
        enc -fstype=cifs,username=mafro,password={{ pillar['jorg_samba_password'] }} ://192.168.1.104/Backup
