include:
  - networking.systemd


{% set wdev = pillar.get('wifi_device', 'wlan0') %}


wireless-tools:
  pkg.installed


# Create networkd config for wireless device
systemd-networkd-wlan:
  file.managed:
    - name: /etc/systemd/network/01-wireless.network
    - contents: |
        [Match]
        Name={{ wdev }}

        [Network]
        DHCP=ipv4

        [DHCPv4]
        UseDomains=true
    - require_in:
      - service: systemd-networkd


/etc/wpa_supplicant/wpa_supplicant-{{ wdev }}.conf:
  file.managed:
    - mode: 600
    - contents: |
        ctrl_interface=DIR=/run/wpa_supplicant
        country=AU

        network={
          ssid="bacon"
          psk={{ pillar.get('wifi_bacon_psk') }}
        }

/etc/wpa_supplicant/wpa_supplicant.conf:
  file.absent

wpa_supplicant:
  service.disabled

wpa_supplicant@{{ wdev }}:
  service.running:
    - enable: true
    - restart: true
    - watch:
      - file: /etc/wpa_supplicant/wpa_supplicant-{{ wdev }}.conf
