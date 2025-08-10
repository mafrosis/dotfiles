samba:
  pkg.installed

smbd:
  service.running:
    - enable: true
    - restart: true
    - require:
      - pkg: samba
    - watch:
      - file: /etc/samba/smb.conf

samba-common-bin:
  pkg.installed

/etc/samba/smb.conf:
  file.append:
    - text: |
        include = /etc/samba/smb.conf.d/*.conf

set-samba-workgroup-eggs:
  file.replace:
    - name: /etc/samba/smb.conf
    - pattern: 'workgroup = WORKGROUP'
    - repl: 'workgroup = EGGS'

/etc/samba/smb.conf.d:
  file.directory

{% for user, args in pillar.get('samba_users', {}).items() %}
create-samba-user-{{ user }}:
  group.present:
    - name: {{ user }}
  user.present:
    - name: {{ user }}
    - createhome: false
    - usergroup: true
    - groups:
      {% for grp in args.get('groups', []) %}
      - {{ grp }}
      {% endfor %}
    - require:
      - group: {{ user }}

set-samba-password-{{ user }}:
  cmd.run:
    - name: printf "{{ args['pass'] }}\n{{ args['pass'] }}" | smbpasswd -s -a {{ user }}
    - require:
      - user: create-samba-user-{{ user }}
{% endfor %}
