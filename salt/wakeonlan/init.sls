wakeonlan:
  pkg.installed

/home/{{ pillar['login_user'] }}/.wakeonlan:
  file.directory:
    - user: {{ pillar['login_user'] }}
    - group: {{ pillar['login_user'] }}
    - mode: 700

{% for hostname, mac_address in pillar['wakeonlan'].iteritems() %}
/home/{{ pillar['login_user'] }}/.wakeonlan/{{ hostname }}:
  file.managed:
    - user: {{ pillar['login_user'] }}
    - group: {{ pillar['login_user'] }}
    - mode: 600
    - contents: "{{ mac_address }} {{ pillar['broadcast_ip'] }}"
{% endfor %}
