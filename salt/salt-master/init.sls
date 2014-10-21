saltstack-pkgrepo:
  pkgrepo.managed:
    - humanname: SaltStack PPA
    - name: deb http://debian.saltstack.com/debian wheezy-saltstack main
    - file: /etc/apt/sources.list.d/saltstack.list
    - key_url: http://debian.saltstack.com/debian-salt-team-joehealy.gpg.key

salt-master-requirements:
  pkg.installed:
    - names:
      - python-jinja2
      - python-git

salt-master:
  pkg.installed:
    - require:
      - pkg: salt-master-requirements
