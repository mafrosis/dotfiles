include:
  - common


/etc/systemd/journald.conf:
  file.append:
    - text: SystemMaxUse=1GB

systemd-timesyncd:
  service.running:
    - enable: true
    - restart: true
    - watch:
      - timezone: /etc/timezone
