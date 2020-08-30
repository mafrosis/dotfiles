# https://github.com/mafrosis/step-ca-on-gcp#sso-for-ssh

include:
  - step-cli

generate-host-cert:
  cmd.run:
    - name: step ssh certificate {{ grains["host"] }} /etc/ssh/ssh_host_ecdsa_key.pub --host --sign --provisioner admin --principal {{ grains["host"] }} --token "$(step ca token kvothe --ssh --host --provisioner admin --password-file <(echo -n '{{ pillar["smallstep_ca"] }}'))" --force
    - unless: test -f /etc/ssh/ssh_host_ecdsa_key.pub-cert
    - require:
      - cmd: bootstrap-step-for-root

/etc/ssh/ca.pub:
  cmd.run:
    - name: step ssh config --roots > /etc/ssh/ca.pub
    - unless: test -f /etc/ssh/ca.pub
    - require:
      - cmd: bootstrap-step-for-root

/etc/ssh/sshd_config:
  file.append:
    - text: |
        TrustedUserCAKeys /etc/ssh/ca.pub
        HostCertificate /etc/ssh/ssh_host_ecdsa_key-cert.pub
        HostKey /etc/ssh/ssh_host_ecdsa_key

sshd-restart:
  service.running:
    - name: ssh
    - enable: true
    - restart: true
    - watch:
      - file: /etc/ssh/sshd_config
      - cmd: generate-host-cert
