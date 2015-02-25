[global]
   workgroup = {{ workgroup }}
   netbios name = {{ host }}
   server string = %h server
   dns proxy = no
   # local master = no
   # socket options = TCP_NODELAY SO_RCVBUF=8192 SO_SNDBUF=8192

   log file = /var/log/samba/log.%m
   max log size = 1000
   syslog = 0
   panic action = /usr/share/samba/panic-action %d
   # mafro
   security = user

   interfaces = lo eth0
   bind interfaces only = true

   encrypt passwords = true
   passdb backend = tdbsam
   obey pam restrictions = yes
   # mafro
   unix password sync = yes
   passwd program = /usr/bin/passwd %u
   passwd chat = *Enter\snew\s*\spassword:* %n\n *Retype\snew\s*\spassword:* %n\n *password\supdated\ssuccessfully* .
   # mafro
   pam password change = yes
   map to guest = bad user

   # mafro
   usershare allow guests = no

#======================= Share Definitions =======================

[homes]
   comment = Home Directories
   browseable = no
   read only = yes
   create mask = 0700
   directory mask = 0700
   valid users = %S

{% if host == "monopoly" %}
[Download]
   comment = Download
   path = /media/pools/download
   browseable = yes
   read only = no
   create mask = 0660
   directory mask = 0770
   valid users = mafro

[data]
   comment = data
   path = /media/pools/data
   browseable = yes
   read only = no
   create mask = 0660
   directory mask = 0770
   valid users = mafro

[Backup]
   comment = Backup
   path = /media/enc/beta
   browseable = yes
   read only = no
   create mask = 0660
   directory mask = 0770
   valid users = mafro

[Video]
   comment = Video
   path = /media/pools/video
   browseable = yes
   read only = yes
   valid users = mafro xbmc
{% endif %}
