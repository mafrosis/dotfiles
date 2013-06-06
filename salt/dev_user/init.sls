include:
  - common

# install some extra packages
{% for package_name in pillar.get('extras', []) %}
extra_{{ package_name }}:
  pkg.installed:
    - name: {{ package_name }}
{% endfor %}

# set the default shell
modify-shell-user:
  user.present:
    - name: {{ grains['user'] }}
    - shell: /bin/{{ pillar['shell'] }}

git:
  pkg:
    - installed

# grab the user's dotfiles
dotfiles:
  git.latest:
    - name: git@github.com:{{ pillar['github_username'] }}/dotfiles.git
    - rev: master
    - target: /home/{{ grains['user'] }}/dotfiles
    - runas: {{ grains['user'] }}
    - require:
      - pkg: git
  cmd.wait:
    - name: git submodule update --init
    - cwd: /home/{{ grains['user'] }}/dotfiles
    - user: {{ grains['user'] }}
    - watch:
      - git: dotfiles

# run dotfiles install script
install-dotfiles:
  cmd.run:
    - name: ./install.sh vim zsh tmux git
    - onlyif: ls /home/{{ grains['user'] }}/dotfiles | grep install.sh
    - cwd: /home/{{ grains['user'] }}/dotfiles
    - user: {{ grains['user'] }}
    - require:
      - cmd: dotfiles

python-pip:
  pkg:
    - installed

# recent version of virtualenvwrapper
virtualenvwrapper:
  pip.installed:
    - require:
      - pkg: python-pip
