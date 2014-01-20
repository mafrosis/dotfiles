{% if grains.get('vmware', False) %}
login_user: vagrant
{% else %}
login_user: mafro
{% endif %}

samba_users:
  xbmc:
    pass: xbmc
    groups:
      - video

smb_workgroup: EGGS
