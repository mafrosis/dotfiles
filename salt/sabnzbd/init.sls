include:
  - debian-repos.contrib
  - debian-repos.nonfree

{% set user = pillar.get('login_user', 'vagrant') %}
{% set sabnzbd_basedir = pillar.get('sabnzbd_basedir', '/home/'+user+'/usenet') %}

sabnzbd-reqs:
  pkg.installed:
    - names:
      - par2
      - unrar

sabnzbd-download-group:
  group.present:
    - name: download

create-sabnzbd-user:
  user.present:
    - name: sabnzbd
    - home: /home/sabnzbd
    - shell: /bin/bash
    - gid: download
    - remove_groups: false
    - require:
      - group: download

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
    - repl: "USER=sabnzbd"

sabnzbd-patch-host:
  file.replace:
    - name: /etc/default/sabnzbdplus
    - pattern: "^HOST=.*"
    - repl: "HOST={{ salt['cmd.run']("hostname -I | awk '/.*/ {print $1}'") }}"

sabnzbd-patch-port:
  file.replace:
    - name: /etc/default/sabnzbdplus
    - pattern: "^PORT=.*"
    - repl: "PORT=7654"

sabnzbd-patch-config:
  file.replace:
    - name: /etc/default/sabnzbdplus
    - pattern: "^CONFIG=.*"
    - repl: "CONFIG=/home/sabnzbd/sabnzbd.ini"

{{ sabnzbd_basedir }}:
  file.directory:
    - user: {{ user }}
    - group: download
    - dir_mode: 770

{% for dir in ('complete', 'incomplete', 'watch'): %}
{{ sabnzbd_basedir }}/{{ dir }}:
  file.directory:
    - user: sabnzbd
    - group: download
    - dir_mode: 770
{% endfor %}

# config file must be in sabnzbd user's $HOME, since it writes
# files relative to the INI file path
sabnzbd-config:
  file.managed:
    - name: /home/sabnzbd/sabnzbd.ini
    - source: salt://sabnzbd/sabnzbd.ini
    - template: jinja
    - user: sabnzbd
    - defaults:
        host: "{{ salt['cmd.run']("hostname -I | awk '/.*/ {print $1}'") }}"
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
