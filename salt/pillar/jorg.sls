login_user: mafro

rtorrent_download_dir: /media/download/rtorrent
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

usenet_servers:
  astraweb:
    host: ssl-eu.astraweb.com
    user: mafrosis44
    num_conns: 6
  tweaknews:
    host: news.tweaknews.eu
    user: tw1417222
    num_conns: 8
    priority: 1
