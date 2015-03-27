{% if grains.get('vmware', False) %}

login_user: vagrant
rtorrent_download_dir: /home/vagrant/download

{% else %}

login_user: mafro
rtorrent_download_dir: /home/mafro/download

{% endif %}
