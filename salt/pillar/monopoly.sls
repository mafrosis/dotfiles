{% if grains.get('vmware', False) %}
login_user: vagrant
{% else %}
login_user: mafro
{% endif %}
