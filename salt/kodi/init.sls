include:
  - kodi.sudoers
  - debian.backports


kodi:
  pkg.latest:
    - fromrepo: debian-backports
  user.present:
    - name: kodi
    - gid: video
    - groups:
      - audio
      - video
  file.managed:
    - name: /etc/systemd/system/kodi.service
    - contents: |
        [Unit]
        Description = Kodi Media Center
        After = systemd-user-sessions.service sound.target

        [Service]
        Type = simple
        User = kodi
        Group = video
        PAMName = login

        TTYPath = /dev/tty1
        ExecStart = startx /usr/bin/kodi-standalone -- :0 -nolisten tcp vt1
        ExecStop = /usr/bin/killall --user kodi --exact --wait kodi.bin

        Restart = on-abort
        RestartSec = 5

        StandardInput = tty
        StandardOutput = journal

        [Install]
        WantedBy = multi-user.target
    - user: {{ pillar.get('login_user', 'root') }}
    - mode: 644
  service.running:
    - enable: true
    - watch:
      - file: kodi
    - require:
      - pkg: kodi
      - user: kodi

add-mafro-to-video:
  user.present:
    - name: mafro
    - remove_groups: false
    - groups:
      - video

xserver-xorg:
  pkg.installed

xinit:
  pkg.installed

{% if grains['os'] == 'Debian' %}
# Graphics driver for the Intel NUC
xserver-xorg-video-intel:
  pkg.installed
{% endif %}
