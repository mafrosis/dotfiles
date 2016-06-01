{% if grains.get('vmware', false) %}

login_user: vagrant
rtorrent_download_dir: /home/vagrant/download

{% else %}

hostname: kerplunk
login_user: mafro
rtorrent_download_dir: /media/download/rtorrent
sabnzbd_basedir: /media/download/usenet

custom_segments:
  zfs: "160 255"
  enc: "36 255"
  backup: "166 255"

{% endif %}

bootstrap_dotfiles_cmd: ./install.sh -f zsh vim git tmux inputrc
