{% set ssh_user = pillar.get('app_user', pillar.get('login_user', 'vagrant')) %}

ssh-home-dir:
  file.directory:
    - name: /home/{{ ssh_user }}/.ssh
    - user: {{ ssh_user }}
    - group: {{ ssh_user }}
    - mode: 700

ssh-config:
  file.managed:
    - name: /home/{{ ssh_user }}/.ssh/config
    - contents: |
        Host github.com
            IdentityFile ~/.ssh/github.{{ grains['host'] }}.pky
    - user: {{ ssh_user }}
    - group: {{ ssh_user }}
    - mode: 600
    - replace: false
    - require:
      - file: ssh-home-dir

github_known_hosts:
  ssh_known_hosts.present:
    - name: github.com
    - user: {{ ssh_user }}
    - fingerprint: 16:27:ac:a5:76:28:2d:36:63:1b:56:4d:eb:df:a6:48
    - require:
      - file: ssh-home-dir

{% if pillar.get('github_key', false) %}
github.pky:
  file.managed:
    - contents_pillar: github_key
    - name: /home/{{ ssh_user }}/.ssh/github.{{ grains['host'] }}.pky
    - user: {{ ssh_user }}
    - group: {{ ssh_user }}
    - mode: 600
    - require:
      - file: ssh-config
      - ssh_known_hosts: github_known_hosts
    - order: first

{% elif pillar.get('github_key_path', false) %}
github.pky:
  file.managed:
    - source: salt://{{ pillar['github_key_path'] }}
    - name: /home/{{ ssh_user }}/.ssh/github.{{ grains['host'] }}.pky
    - user: {{ ssh_user }}
    - group: {{ ssh_user }}
    - mode: 600
    - require:
      - file: ssh-config
      - ssh_known_hosts: github_known_hosts
    - order: first

{% endif %}
