wakeonlan:
  pkg.installed

/home/{{ pillar['login_user'] }}/.wakeonlan:
  file.directory:
    - user: {{ pillar['login_user'] }}
    - group: {{ pillar['login_user'] }}
    - mode: 700

/home/{{ pillar['login_user'] }}/.wakeonlan/kerplunk:
  file.managed:
    - user: {{ pillar['login_user'] }}
    - group: {{ pillar['login_user'] }}
    - mode: 600
    - contents: "00:00:00:00:00:00 192.168.1.255"

/home/{{ pillar['login_user'] }}/.wakeonlan/monopoly:
  file.managed:
    - user: {{ pillar['login_user'] }}
    - group: {{ pillar['login_user'] }}
    - mode: 600
    - contents: "00:00:00:00:00:00 192.168.1.255"
