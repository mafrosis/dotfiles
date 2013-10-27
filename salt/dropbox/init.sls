{% set user = pillar.get('login_user', 'mafro') %}

dropbox-installer:
  file.managed:
    - name: /tmp/dropbox-lnx-2.6.2.tar.gz
    {% if grains["osarch"] == "amd64" %}
    - source: https://dl.dropboxusercontent.com/u/17/dropbox-lnx.x86_64-2.6.2.tar.gz
    - source_hash: md5=130e6f895309d953a7d884538fc97746
    {% else %}
    - source: https://dl.dropboxusercontent.com/u/17/dropbox-lnx.x86-2.6.2.tar.gz
    - source_hash: md5=06f0370e55e700f7c78f206101550a4b
    {% endif %}
    - user: {{ user }}
    - group: {{ user }}
  cmd.wait:
    - name: tar xzf /tmp/dropbox-lnx-2.6.2.tar.gz
    - cwd: /tmp
    - user: {{ user }}
    - watch:
      - file: dropbox-installer

dropbox-cli:
  file.managed:
    - name: /usr/local/bin/dropbox
    - source: https://www.dropbox.com/download?dl=packages/dropbox.py
    - source_hash: md5=96e41f2027a3a5da1cc569be489a108b
    - user: {{ user }}
    - group: {{ user }}
    - mode: 700
