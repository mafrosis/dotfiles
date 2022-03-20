# Configure sshd to expect another authorized_keys file
/etc/ssh/sshd_config.d/authorized-keys.conf:
  file.managed:
    - contents: |
        AuthorizedKeysFile .ssh/authorized_keys .ssh/authorized_breakglass_keys
  cmd.wait:
    - name: systemctl restart ssh
    - watch:
      - file: /etc/ssh/sshd_config.d/authorized-keys.conf
