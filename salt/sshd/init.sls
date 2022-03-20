include:
  - sshd.breakglass
  - sshd.step-ca-host-certs


# Add an include line to the sshd config
/etc/ssh/sshd_config:
  file.blockreplace:
    - content: |
        
        Include /etc/ssh/sshd_config.d/*.conf
    - marker_start: '# default value'
    - marker_end: '#Port 22'
    - append_newline: true

/etc/ssh/sshd_config.d:
  file.directory

# Setup baseline SSH hardening
/etc/ssh/sshd_config.d/baseline.conf:
  file.managed:
    - contents: |
        LogLevel VERBOSE

        LoginGraceTime 30
        MaxAuthTries 3
        MaxSessions 2

        PermitRootLogin no
        PermitTunnel no
        PermitEmptyPasswords no
        X11Forwarding no
        PrintMotd no
  cmd.wait:
    - name: systemctl restart ssh
    - watch:
      - file: /etc/ssh/sshd_config.d/baseline.conf

# Set modern crypto defaults based on
# https://infosec.mozilla.org/guidelines/openssh
/etc/ssh/sshd_config.d/algorithms.conf:
  file.managed:
    - contents: |
        KexAlgorithms curve25519-sha256@libssh.org,ecdh-sha2-nistp521,ecdh-sha2-nistp384,ecdh-sha2-nistp256,diffie-hellman-group-exchange-sha256
        Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
        MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-512,hmac-sha2-256,umac-128@openssh.com
  cmd.wait:
    - name: systemctl restart ssh
    - watch:
      - file: /etc/ssh/sshd_config.d/algorithms.conf

# Disable password login everywhere
/etc/ssh/sshd_config.d/nopassauth.conf:
  file.managed:
    - contents: |
        PasswordAuthentication no
        AuthenticationMethods publickey
  cmd.wait:
    - name: systemctl restart ssh
    - watch:
      - file: /etc/ssh/sshd_config.d/nopassauth.conf
