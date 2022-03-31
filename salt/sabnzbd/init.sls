{% set user = pillar['login_user'] %}

# Install the SABnzbd config into the docker directory on target host
sabnzbd-config:
  file.managed:
    - name: /home/{{ user }}/dotfiles/tools/sabnzbd/sabnzbd.ini
    - source: salt://sabnzbd/sabnzbd.ini
    - template: jinja
    - user: {{ user }}
    - defaults:
        hostname: {{ grains['host'] }}
        download_dir: /incomplete
        complete_dir: /complete
