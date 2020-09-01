include:
  - realtek-rtl8821


/etc/netplan/01-wifi.yaml:
  file.managed:
    - contents: |
        network:
          ethernets:
            enp0s25:
              addresses: []
              dhcp4: true
              optional: true
              nameservers:
                addresses: [192.168.1.1]
          wifis:
            wlx002e2dab528d:
              dhcp4: yes
              access-points:
                bacon:
                  password: "bafoEMMhCgZ8btejx@AB"
          version: 2
  cmd.wait:
    - name: netplan apply
    - watch:
      - file: /etc/netplan/01-wifi.yaml
