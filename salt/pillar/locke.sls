{% if grains.get('id', 'vagrant') %}

login_user: vagrant
rtorrent_download_dir: /home/vagrant/download

{% else %}

hostname: kerplunk
login_user: mafro
rtorrent_download_dir: /media/download/rtorrent
sabnzbd_basedir: /media/download/usenet

{% endif %}

bootstrap_dotfiles_cmd: ./install.sh -f zsh vim git tmux inputrc
