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
