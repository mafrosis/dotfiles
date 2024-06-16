include:
  - step.cli

# Add CA public cert to sshd
/etc/ssh/mafro-ca.pub:
  file.managed:
    - contents: "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBLUyeZthMLAUaZAxAh9CsI+d4COx67Huyc/iX0kPCoLnEzaJ49MbYu7KQWdo/2PALsoIrUZQhY1jmxrFy5Wao5s="

# Generate an SSH host cert for sshd
/etc/ssh/ssh_host_ecdsa_key-cert.pub:
  cmd.script:
    - source: salt://sshd/step-sshd-host-cert.sh
    - creates: /etc/ssh/ssh_host_ecdsa_key-cert.pub
    - env:
      - SMALLSTEP_CA_PASSWORD: "{{ pillar['smallstep_ca'] }}"
    - require:
      - file: /etc/step_root_ca.crt
      - file: step-cli-defaults-root

# Configure sshd to trust Step CA, and to use the SSH host cert
/etc/ssh/sshd_config.d/step-ca.conf:
  file.managed:
    - contents: |
        TrustedUserCAKeys /etc/ssh/mafro-ca.pub
        HostCertificate /etc/ssh/ssh_host_ecdsa_key-cert.pub
        HostKey /etc/ssh/ssh_host_ecdsa_key
    - require:
      - file: /etc/ssh/mafro-ca.pub
      - cmd: /etc/ssh/ssh_host_ecdsa_key-cert.pub
  cmd.wait:
    - name: systemctl restart ssh
    - watch:
      - file: /etc/ssh/sshd_config.d/step-ca.conf
