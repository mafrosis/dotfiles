{% if grains.get('vmware', false) %}

login_user: vagrant
rtorrent_download_dir: /home/vagrant/torrent

{% else %}

hostname: monopoly
login_user: mafro
rtorrent_download_dir: /media/download

zpool_import: True

samba_users:
  xbmc:
    pass: xbmc
    groups:
      - video

smb_workgroup: EGGS

custom_segments:
  enc: "36 255"
  backup: "166 255"

{% endif %}
