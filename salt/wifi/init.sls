dhcpcd-restart-systemd-script:
  file.managed:
    - name: /etc/systemd/system/dhcpcd-restart.service
    - contents: |
        [Unit]
        Description=DHCPcd Restart
        After=network.target

        [Service]
        User=root	
        Type=oneshot
        ExecStart=/home/{{ pillar.get('login_user', 'root') }}/dotfiles/salt/wifi/dhcpcd-restart.sh
        RemainAfterExit=yes

        [Install]
        WantedBy=multi-user.target
    - mode: 644

dhcpcd-restart-service-enable:
  service.enabled:
    - name: dhcpcd-restart
    - require:
      - file: dhcpcd-restart-systemd-script
