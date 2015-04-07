include:
  - dev-user

dotfiles-install-xbmc:
  cmd.run:
    - name: ./install.sh -f xbmc
    - cwd: /home/{{ pillar['login_user'] }}/dotfiles
    - user: {{ pillar['login_user'] }}
    - require:
      - git: dotfiles
