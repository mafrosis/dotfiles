include:
  - supervisor

{% set user = pillar['login_user'] %}
{% set sabnzbd_user = pillar.get('sabnzbd_user', 'sabnzbd') %}
{% set sabnzbd_group = pillar.get('sabnzbd_user', 'download') %}

# create download group
sabnzbd-download-group:
  group.present:
    - name: {{ sabnzbd_group }}

# add login_user to download group
sabnzbd-adduser-group:
  group.present:
    - name: download
    - addusers:
      - {{ pillar['login_user'] }}

create-sabnzbd-user:
  user.present:
    - name: {{ sabnzbd_user }}
    - home: /home/{{ sabnzbd_user }}
    - gid: {{ sabnzbd_group }}
    - remove_groups: false
    - require:
      - group: {{ sabnzbd_group }}

/home/{{ user }}/usenet:
  file.directory:
    - user: {{ user }}
    - group: {{ sabnzbd_group }}
    - dir_mode: 770

# config file must be in sabnzbd user's $HOME, since it writes
# files relative to the INI file path
sabnzbd-config:
  file.managed:
    - name: /home/{{ sabnzbd_user }}/sabnzbd.ini
    - source: salt://sabnzbd/sabnzbd.ini
    - template: jinja
    - user: {{ sabnzbd_user }}
    - defaults:
        hostname: {{ pillar['hostname'] }}
        download_dir: /incomplete
        complete_dir: /complete
