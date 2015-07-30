{% if grains.get('vmware', False) %}

login_user: vagrant
rtorrent_download_dir: /home/vagrant/download

{% else %}

hostname: kerplunk
login_user: mafro
rtorrent_download_dir: /home/mafro/download

custom_segments:
  enc: "36 255"
  backup: "166 255"

{% endif %}
