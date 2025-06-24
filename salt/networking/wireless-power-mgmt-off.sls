wlan-always-on@wlan0:
  file.managed:
    - name: /etc/systemd/system/wlan-always-on@.service
    - mode: 644
    - contents: |
        [Unit]
        Description=Keep wireless device %i from sleeping.
        After=network.target

        [Service]
        ExecStart=/sbin/iwconfig %i power off

        [Install]
        WantedBy=default.target
  service.enabled:
    - reload: true
    - watch:
      - file: wlan-always-on@wlan0
