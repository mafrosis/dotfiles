################################################
#
# Configure the local user for development
# - Set the local user's shell
# - Pull some dotfiles and run a bootstrap command
# - On Debian, ensure git comes from backports
# - Install some arbitrary extra packages defined in pillar
#
# Pillar vars of use:
# - login_user: name of the user to setup (default: vagrant)
# - github_username: username hosting "dotfiles" repo on github
# - shell: user's shell (default: bash)
# - extras: array of apt packages to install (default: [])
# - pip: array of pip packages to install (default: [])
# - bootstrap_dotfiles_cmd: script to setup your dotfiles (default: "bootstrap")
#
################################################

{% set shell = pillar.get('shell', 'bash') %}
{% set login_user = pillar.get('login_user', 'vagrant') %}

include:
  - common
  {% if grains['os'] == "Debian" %}
  - debian-repos.backports
  {% endif %}
  - sudo

dev_packages:
  pkg.latest:
    - names:
      - curl
      - man-db
      - telnet
      - htop
      - stow

# install extra packages from apt
{% for package_name in pillar.get('extras', []) %}
  {% if package_name == "vim" and grains['os'] == "Debian" %}
  {% set package = "vim-nox" %}
  {% else %}
  {% set package = package_name %}
  {% endif %}

extra_{{ package_name }}:
  pkg.latest:
    - name: {{ package }}
{% endfor %}

# install extra packages from pip
{% for package_name in pillar.get('pip', []) %}
extra_{{ package_name }}:
  pip.installed:
    - name: {{ package_name }}
{% endfor %}


# set the default shell
shell-{{ shell }}:
  pkg.installed:
    - name: {{ shell }}

modify-login-user:
  user.present:
    - name: {{ login_user }}
    - shell: /bin/{{ shell }}
    - remove_groups: false
    - unless: getent passwd $LOGNAME | grep {{ shell }}
    - require:
      - pkg: shell-{{ shell }}


{% if grains['os'] == "Debian" %}
extend:
  git:
    pkg.latest:
      - fromrepo: {{ grains['oscodename'] }}-backports
      - require:
        - pkgrepo: backports-pkgrepo
{% endif %}

github_known_hosts-dotfiles:
  ssh_known_hosts.present:
    - name: github.com
    - user: {{ login_user }}
    - fingerprint: 16:27:ac:a5:76:28:2d:36:63:1b:56:4d:eb:df:a6:48

# grab the user's dotfiles
dotfiles:
  git.latest:
    - name: https://github.com/{{ pillar['github_username'] }}/dotfiles.git
    - target: /home/{{ login_user }}/dotfiles
    - user: {{ login_user }}
    - submodules: true
    - unless: test -d /home/{{ login_user }}/dotfiles/.git
    - require:
      - pkg: git
      - ssh_known_hosts: github.com


# execute from pillar bootstrap_dotfiles_cmd, or script named "bootstrap"
{% if pillar.get('bootstrap_dotfiles_cmd', false) %}
bootstrap-dotfiles:
  cmd.run:
    - name: /bin/{{ shell }} {{ pillar['bootstrap_dotfiles_cmd'] }}
    - cwd: /home/{{ login_user }}/dotfiles
    - user: {{ login_user }}
    - require:
      - git: dotfiles
{% else %}
bootstrap-dotfiles:
  cmd.run:
    - name: /bin/{{ shell }} bootstrap
    - cwd: /home/{{ login_user }}/dotfiles
    - user: {{ login_user }}
    - require:
      - git: dotfiles
{% endif %}
