samba:
  pkg:
    - installed
  service.running:
    - enable: true
    - require:
      - pkg: samba
    - watch:
      - file: /etc/samba/smb.conf

samba-common-bin:
  pkg.installed

/etc/samba/smb.master.conf:
  file.managed:
    - source: salt://samba/smb.master.conf

/etc/samba/smb.conf:
  file.managed:
    - source: salt://samba/smb.conf.sls
    - template: jinja
    - defaults:
        host: {{ grains['host'] }}
        workgroup: {{ pillar['smb_workgroup'] }}

{% for user, args in pillar.get('samba_users', {}).iteritems() %}
create-samba-user-{{ user }}:
  group.present:
    - name: {{ user }}
  user.present:
    - name: {{ user }}
    - createhome: false
    - gid_from_name: true
    - groups:
      {% for grp in args['groups'] %}
      - {{ grp }}
      {% endfor %}
    - require:
      - group: {{ user }}

set-samba-password-{{ user }}:
  cmd.run:
    - name: echo -e "{{ args['pass'] }}\n{{ args['pass'] }}" | smbpasswd -s -a {{ user }}
    - require:
      - user: create-samba-user-{{ user }}
{% endfor %}
