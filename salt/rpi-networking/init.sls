/etc/wpa_supplicant/wpa_supplicant.conf:
  file.managed:
    - source: salt://rpi-networking/wpa_supplicant.conf
    - template: jinja
    - context:
        ssid: {{ pillar['rpi-ssid'] }}
        psk: {{ pillar['rpi-wpa_password'] }}

#{% if pillar.get("mac_address", False) %}
#
#/etc/network/interfaces:
#  file.append:
#    - text: "hwaddress ether {{ pillar['mac_address'] }}"
#
#{% endif %}
