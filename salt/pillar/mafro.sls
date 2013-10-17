{% if grains.get('vmware', False) %}
login_user: vagrant
{% else %}
login_user: mafro
{% endif %}
github_username: mafrosis
shell: zsh
extras:
  - vim
  - zsh
  - tmux
  - pyflakes

# set backports to AU in bit.ly/19Nso9M
deb_mirror_prefix: ftp.au
