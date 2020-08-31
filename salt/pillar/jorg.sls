{% if grains.get('vmware', false) %}

login_user: vagrant
rtorrent_download_dir: /home/vagrant/torrent

{% else %}

hostname: jorg
login_user: mafro
rtorrent_download_dir: /media/download/rtorrent
sabnzbd_basedir: /media/download/usenet

rtorrent_download_rate: 5000
rtorrent_upload_rate: 70

samba_users:
  mafro:
    pass: eggs
  kodi:
    pass: kodi
    groups:
      - video

smb_workgroup: EGGS

{% endif %}
