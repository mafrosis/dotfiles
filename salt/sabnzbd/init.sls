include:
  - debian-repos.contrib
  - debian-repos.nonfree

{% set user = pillar.get('login_user', 'vagrant') %}
{% set sabnzbd_basedir = pillar.get('sabnzbd_basedir', '/home/'+user+'/usenet') %}
{% set sabnzbd_user = pillar.get('sabnzbd_user', 'sabnzbd') %}
{% set sabnzbd_group = pillar.get('sabnzbd_user', 'download') %}

sabnzbd-reqs:
  pkg.installed:
    - names:
      - par2
      - unrar

sabnzbd-download-group:
  group.present:
    - name: {{ sabnzbd_group }}

create-sabnzbd-user:
  user.present:
    - name: {{ sabnzbd_user }}
    - home: /home/{{ sabnzbd_user }}
    - gid: {{ sabnzbd_group }}
    - remove_groups: false
    - require:
      - group: {{ sabnzbd_group }}

sabnzbdplus.service:
  file.managed:
    - name: /etc/systemd/system/sabnzbdplus.service
    - source: salt://sabnzbd/sabnzbdplus.service
    - template: jinja
    - context:
        sabnzbd_basedir: {{ sabnzbd_basedir }}
        sabnzbd_user: {{ sabnzbd_user }}
        sabnzbd_group: {{ sabnzbd_group }}
        download_dir: {{ sabnzbd_basedir }}/incomplete
        complete_dir: {{ sabnzbd_basedir }}/complete
        uid: {{ salt['cmd.shell']("id -u "+sabnzbd_user) }}
        gid: {{ salt['cmd.shell']("id -g "+sabnzbd_group) }}
    - require:
      - user: {{ sabnzbd_user }}
  module.run:
    - name: service.systemctl_reload
    - onchanges:
      - file: sabnzbdplus.service

sabnzbdplus:
  service.running:
    - watch:
      - module: sabnzbdplus.service

{{ sabnzbd_basedir }}:
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
        download_dir: {{ sabnzbd_basedir }}/incomplete
        complete_dir: {{ sabnzbd_basedir }}/complete
        oznzb_key: "{{ pillar.get('oznzb_key', '') }}"
        sabnzbd_api_key: "{{ pillar.get('sabnzbd_api_key', '') }}"
        sabnzbd_nzb_key: "{{ pillar.get('sabnzbd_nzb_key', '') }}"
  cmd.wait:
    - name: systemctl restart sabnzbdplus.service
    - watch:
      - file: sabnzbd-config
