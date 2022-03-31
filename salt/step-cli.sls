{% set smallstep_version = "0.18.2" %}

install-step-cli:
  archive.extracted:
    - name: /var/cache/dotfiles/step
    {% if grains["cpuarch"] == "armv7l" %}
    - source: https://github.com/smallstep/cli/releases/download/v{{ smallstep_version }}/step_linux_{{ smallstep_version }}_armv7.tar.gz
    - source_hash_name: step_linux_{{ smallstep_version }}_armv7.tar.gz
    {% else %}
    - source: https://github.com/smallstep/cli/releases/download/v{{ smallstep_version }}/step_linux_{{ smallstep_version }}_amd64.tar.gz
    - source_hash_name: step_linux_{{ smallstep_version }}_amd64.tar.gz
    {% endif %}
    - source_hash: https://github.com/smallstep/cli/releases/download/v{{ smallstep_version }}/checksums.txt
    - source_hash_update: true
  cmd.wait:
    - name: cp /var/cache/dotfiles/step/step_{{ smallstep_version }}/bin/step /usr/local/bin/step
    - watch:
      - archive: install-step-cli

{% set user = pillar["login_user"] %}

bootstrap-step-for-{{ user }}:
  cmd.run:
    - name: step ca bootstrap --force --ca-url {{ pillar.get('smallstep_ca_host', 'https://ca.mafro.net:4433') }} --fingerprint {{ pillar["smallstep_ca_root_fingerprint"] }}
    - creates: /home/{{ user }}/.step/config/defaults.json
    - runas: {{ user }}
    - require:
      - cmd: install-step-cli

bootstrap-step-for-root:
  cmd.run:
    - name: step ca bootstrap --force --ca-url {{ pillar.get('smallstep_ca_host', 'https://ca.mafro.net:4433') }} --fingerprint {{ pillar["smallstep_ca_root_fingerprint"] }}
    - creates: /root/.step/config/defaults.json
    - require:
      - cmd: install-step-cli
