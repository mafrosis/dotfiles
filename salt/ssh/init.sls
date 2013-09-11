{% set ssh_user = pillar.get('app_user', pillar['login_user']) %}

ssh-home-dir:
  file.directory:
    - name: /home/{{ ssh_user }}/.ssh
    - user: {{ ssh_user }}
    - group: {{ ssh_user }}
    - mode: 700

ssh-config:
  file.managed:
    - name: /home/{{ ssh_user }}/.ssh/config
    - source: salt://ssh/ssh_config
    - user: {{ ssh_user }}
    - group: {{ ssh_user }}
    - mode: 600
    - replace: false
    - require:
      - file: /home/{{ ssh_user }}/.ssh

github_known_hosts:
  ssh_known_hosts.present:
    - name: github.com
    - user: {{ ssh_user }}
    - fingerprint: 16:27:ac:a5:76:28:2d:36:63:1b:56:4d:eb:df:a6:48
    - require:
      - file: /home/{{ ssh_user }}/.ssh

{% if pillar.get('github_key_path', False) %}
github.pky:
  file.managed:
    - source: salt://{{ pillar['github_key_path'] }}
    - name: /home/{{ ssh_user }}/.ssh/github.pky
    - user: {{ ssh_user }}
    - group: {{ ssh_user }}
    - mode: 600
    - require:
      - file: /home/{{ ssh_user }}/.ssh/config
      - ssh_known_hosts: github_known_hosts
    - order: first
{% endif %}
