{% if grains.get('vmware', False) %}

login_user: vagrant
rtorrent_download_dir: /home/vagrant/torrent

{% else %}

login_user: mafro
rtorrent_download_dir: /media/pools/download

{% endif %}

samba_users:
  xbmc:
    pass: xbmc
    groups:
      - video

smb_workgroup: EGGS
