include:
  - step.root-ca-cert

{% set smallstep_version = '0.23.0' %}

install-step-cli:
  archive.extracted:
    - name: /var/cache/dotfiles/step
    {% if grains['cpuarch'] == 'armv7l' %}
    - source: https://github.com/smallstep/cli/releases/download/v{{ smallstep_version }}/step_linux_{{ smallstep_version }}_armv7.tar.gz
    - source_hash_name: step_linux_{{ smallstep_version }}_armv7.tar.gz
    {% elif grains['cpuarch'] == 'aarch64' %}
    - source: https://github.com/smallstep/cli/releases/download/v{{ smallstep_version }}/step_linux_{{ smallstep_version }}_arm64.tar.gz
    - source_hash_name: step_linux_{{ smallstep_version }}_arm64.tar.gz
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

step-ca-group:
  user.present:
    - name: {{ pillar['login_user'] }}
    - optional_groups:
      - step-ca
    - require:
      - group: step-ca

{% for user in ['root', pillar['login_user']]: %}

{% if user == 'root': %}
{% set home_path = '/root' %}
{% else %}
{% set home_path = '/home/'+pillar['login_user'] %}
{% endif %}

step-cli-defaults-{{ user }}:
  file.serialize:
    - name: {{ home_path }}/.step/config/defaults.json
    - dir_mode: 700
    - mode: 600
    - user: {{ user }}
    - group: {{ user }}
    - makedirs: true

    - dataset:
        ca-url: '{{ pillar.get('smallstep_ca_host', 'https://ca.mafro.net:4433') }}'
        fingerprint: '{{ pillar['smallstep_ca_root_fingerprint'] }}'
        root: '/etc/step_root_ca.crt'
        redirect-url: ''
    - serializer: json

step completion zsh > {{ home_path }}/.step/zsh_completion:
  cmd.run:
    - user: {{ user }}
{% endfor %}
