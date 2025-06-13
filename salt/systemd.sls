include:
  - common


/etc/systemd/journald.conf:
  file.append:
    - text: SystemMaxUse=1GB

systemd-timesyncd:
  pkg:
    - installed
  service.running:
    - enable: true
    - restart: true
    - watch:
      - timezone: /etc/timezone
