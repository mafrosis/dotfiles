{{ set user = pillar.get('login_user', 'vagrant') }}

beets:
  - pip.installed

beets-requests:
  pip.installed:
    - name: requests

/home/{{ user }}/.config/beets:
  file.directory:
    - user: {{ user }}
    - group: {{ user }}

/home/{{ user }}/dotfiles/salt/mp3/beets.config.yaml
  file.symlink:
    - name: /home/{{ user }}/.config/beets/config.yaml
