{% if grains['os'] == "MacOS" and grains['saltversion'].startswith("2014.7.0") %}

/usr/local/Cellar/saltstack/2014.7.1/lib/python2.7/site-packages/salt/modules/brew.py:
  file.managed:
    - source: salt://salt-backports/brew.2014-7-0.module.py

#salt-backports-restart:
#  cmd.run:
#    - name: service salt-minion restart
#    - watch:
#      - file: /usr/lib/python2.7/dist-packages/salt/states/rabbitmq_user.py
#    - order: 1

{% endif %}
