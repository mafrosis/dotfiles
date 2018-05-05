include:
  - supervisor

{% set user = pillar.get('login_user', 'vagrant') %}
{% set sabnzbd_basedir = pillar.get('sabnzbd_basedir', '/home/'+user+'/usenet') %}
{% set sabnzbd_user = pillar.get('sabnzbd_user', 'sabnzbd') %}
{% set sabnzbd_group = pillar.get('sabnzbd_user', 'download') %}

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

{{ sabnzbd_basedir }}:
  file.directory:
    - user: {{ user }}
    - group: {{ sabnzbd_group }}
    - dir_mode: 770

sabnzbd-supervisor:
  supervisord.running:
    - name: sabnzbd
    - update: true
    - require:
      - service: supervisor
      - file: sabnzbd-supervisor-config

sabnzbd-supervisor-config:
  file.managed:
    - name: /etc/supervisor/conf.d/sabnzbd.conf
    - source: salt://sabnzbd/supervisord.conf
    - template: jinja
    - defaults:
        download_gid: 1002
        sabnzbd_uid: 1002
    - require_in:
      - service: supervisor

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
    - name: supervisorctl restart sabnzbd
    - watch:
      - file: sabnzbd-config
