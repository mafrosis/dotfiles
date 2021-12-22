{% set smallstep_version = "0.18.2" %}

install-step-cli:
  archive.extracted:
    - name: /tmp/step
    {% if grains["cpuarch"] == "armv7l" %}
    # armv7
    - source: https://github.com/smallstep/cli/releases/download/v{{ smallstep_version }}/step_linux_{{ smallstep_version }}_armv7.tar.gz
    - source_hash: sha256=ffde3d9253cf2fd688f3b0b3c4428869efede89adede14d7f0b75437b688623c
    {% else %}
    # amd64 (default)
    - source: https://github.com/smallstep/cli/releases/download/v{{ smallstep_version }}/step_linux_{{ smallstep_version }}_amd64.tar.gz
    - source_hash: sha256=6f52d3be8b3b93242bb42f6f194ec0f8f779c8000927e23a07d07c509cb2bb82
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
