{% if grains.get('id', 'vagrant') %}

login_user: vagrant
rtorrent_download_dir: /home/vagrant/download
sabnzbd_basedir: /vagrant/usenet
sabnzbd_user: vagrant
sabnzbd_group: vagrant

{% else %}

hostname: locke
login_user: mafro
rtorrent_download_dir: /media/download/rtorrent
sabnzbd_basedir: /media/download/usenet

alsa_device: hw:0,7

{% endif %}

timezone: Australia/Melbourne
