# get dotfiles from github
github_username: mafrosis

github_key: |
  ""

# install zsh and set as default login shell
shell: zsh

# install extras from apt
extras:
  - vim
  - zsh
  - git
  - tmux

# install extras from pip
pip:
  - pyflakes
  - virtualenvwrapper

# set backports to AU in bit.ly/19Nso9M
deb_mirror_prefix: ftp.au
