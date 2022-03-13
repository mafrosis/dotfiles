{% set smallstep_version = "0.15.14" %}

install-step-cli:
  archive.extracted:
    - name: /tmp/step
    {% if grains["cpuarch"] == "armv6l" %}
    - source: salt://step-{{ smallstep_version }}-armv6.tar.gz
    - source_hash: md5=f5dee2059ae790a5b8ca5376ade53141
    {% elif grains["cpuarch"] == "armv7l" %}
    - source: https://github.com/smallstep/cli/releases/download/v{{ smallstep_version }}/step_linux_{{ smallstep_version }}_armv7.tar.gz
    - source_hash: md5=0f8379e2c678a44e7bbc91967330ef16
    {% else %}
    - source: https://github.com/smallstep/cli/releases/download/v{{ smallstep_version }}/step_linux_{{ smallstep_version }}_amd64.tar.gz
    - source_hash: md5=b2ae7e0affaa066d98c8a01d19861631
    {% endif %}
    - if_missing: /usr/local/bin/step
  cmd.wait:
    - name: mv /tmp/step/step_{{ smallstep_version }}/bin/step /usr/local/bin/step
    - watch:
      - archive: install-step-cli

{% for user in ['root', pillar["login_user"]]: %}
bootstrap-step-for-{{ user }}:
  cmd.run:
    - name: step ca bootstrap --force --ca-url {{ pillar.get('smallstep_ca_host', 'https://ca.mafro.net:4433') }} --fingerprint {{ pillar["smallstep_ca_root_fingerprint"] }}
    - runas: {{ user }}
    - require:
      - cmd: install-step-cli
{% endfor %}
