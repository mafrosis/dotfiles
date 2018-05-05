# get dotfiles from github
github_username: mafrosis

#github_key: |
#  ""

# install zsh and set as default login shell
shell: zsh

# install extras from apt
extras:
  - vim
  - zsh
  - git
  - tmux
  - shellcheck

# install extras from pip
pip:
  - pyflakes
