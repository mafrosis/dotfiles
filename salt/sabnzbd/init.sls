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
    - shell: /bin/bash
    - gid: {{ sabnzbd_group }}
    - remove_groups: false
    - require:
      - group: {{ sabnzbd_group }}

sabnzbdplus:
  pkg.installed:
    - require:
      - pkgrepo: contrib-pkgrepo
  service.running:
    - enable: true
    - reload: true
    - require:
      - pkg: sabnzbdplus

sabnzbd-patch-user:
  file.replace:
    - name: /etc/default/sabnzbdplus
    - pattern: "^USER=.*"
    - repl: "USER={{ sabnzbd_user }}"

sabnzbd-patch-host:
  file.replace:
    - name: /etc/default/sabnzbdplus
    - pattern: "^HOST=.*"
    - repl: "HOST={{ salt['cmd.shell']("hostname -I | awk '/.*/ {print $1}'") }}"

sabnzbd-patch-port:
  file.replace:
    - name: /etc/default/sabnzbdplus
    - pattern: "^PORT=.*"
    - repl: "PORT=7654"

sabnzbd-patch-config:
  file.replace:
    - name: /etc/default/sabnzbdplus
    - pattern: "^CONFIG=.*"
    - repl: "CONFIG=/home/{{ sabnzbd_user }}/sabnzbd.ini"

{{ sabnzbd_basedir }}:
  file.directory:
    - user: {{ user }}
    - group: {{ sabnzbd_group }}
    - dir_mode: 770

{% for dir in ('complete', 'incomplete', 'watch'): %}
{{ sabnzbd_basedir }}/{{ dir }}:
  file.directory:
    - user: {{ sabnzbd_user }}
    - group: {{ sabnzbd_group }}
    - dir_mode: 770
{% endfor %}

# config file must be in sabnzbd user's $HOME, since it writes
# files relative to the INI file path
sabnzbd-config:
  file.managed:
    - name: /home/{{ sabnzbd_user }}/sabnzbd.ini
    - source: salt://sabnzbd/sabnzbd.ini
    - template: jinja
    - user: {{ sabnzbd_user }}
    - defaults:
        host: "{{ salt['cmd.shell']("hostname -I | awk '/.*/ {print $1}'") }}"
        download_dir: {{ sabnzbd_basedir }}/incomplete
        complete_dir: {{ sabnzbd_basedir }}/complete
        dirscan_dir: {{ sabnzbd_basedir }}/watch
        oznzb_key: "{{ pillar.get('oznzb_key', '') }}"
        sabnzbd_api_key: "{{ pillar.get('sabnzbd_api_key', '') }}"
        sabnzbd_nzb_key: "{{ pillar.get('sabnzbd_nzb_key', '') }}"
  cmd.wait:
    - name: systemctl restart sabnzbdplus.service
    - watch:
      - file: sabnzbd-config
