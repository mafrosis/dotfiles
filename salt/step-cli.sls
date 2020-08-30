{% set smallstep_version = "0.14.6" %}

install-step-cli:
  archive.extracted:
    - name: /tmp/step
    {% if grains["osarch"] == "armhf" %}
    - source: https://github.com/smallstep/cli/releases/download/v{{ smallstep_version }}/step_linux_{{ smallstep_version }}_armv7.tar.gz
    - source_hash: md5=8a86343222df74152e2b769b2380acd8
    {% else %}
    - source: https://github.com/smallstep/cli/releases/download/v{{ smallstep_version }}/step_linux_{{ smallstep_version }}_amd64.tar.gz
    - source_hash: md5=76655578c0cb8a508377e587a52c3032
    {% endif %}
    - if_missing: /usr/local/bin/step
  cmd.wait:
    - name: mv /tmp/step/step_{{ smallstep_version }}/bin/step /usr/local/bin/step
    - watch:
      - archive: install-step-cli

{% for user in ['root', pillar["login_user"]]: %}
bootstrap-step-for-{{ user }}:
  cmd.run:
    - name: step ca bootstrap --force --ca-url https://ca.mafro.net --fingerprint {{ pillar["smallstep_ca_root_fingerprint"] }}
    - runas: {{ user }}
    - require:
      - cmd: install-step-cli
{% endfor %}
