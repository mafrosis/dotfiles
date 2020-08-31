/etc/default/grub:
  file.replace:
    - pattern: "GRUB_TIMEOUT=5"
    - repl: "GRUB_TIMEOUT=0"
    - backup: false
  cmd.wait:
    - name: update-grub
    - watch:
      - file: /etc/default/grub
