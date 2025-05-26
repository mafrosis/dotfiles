/etc/ssh/sshd_config.d/nopassauth.conf:
  file:
    - absent

ssh:
  service.running:
    - restart: true
    - watch:
      - file: /etc/ssh/sshd_config.d/nopassauth.conf
