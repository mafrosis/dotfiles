{% if grains.get('vmware', false) %}

login_user: vagrant
rtorrent_download_dir: /home/vagrant/torrent

{% else %}

# zfs from contrib no work with httpredir
#deb_mirror_prefix: ftp.uk

#hostname: monopoly
login_user: mafro
rtorrent_download_dir: /media/download/rtorrent
sabnzbd_basedir: /media/download/usenet

#zpool_import: True

samba_users:
  mafro:
    pass: eggs
  kodi:
    pass: kodi
    groups:
      - video

smb_workgroup: EGGS

custom_segments:
  enc: "36 255"
  backup: "166 255"

{% endif %}

bootstrap_dotfiles_cmd: ./install.sh -f zsh vim git tmux inputrc
