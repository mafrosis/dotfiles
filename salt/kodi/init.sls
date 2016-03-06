include:
  - debian-repos.backports
  - debian-repos.contrib
  - debian-repos.nonfree

kodi:
  user.present:
    - name: kodi
    - gid: video
    - groups:
      - audio
      - video
  pkg.installed:
    - fromrepo: {{ grains['oscodename'] }}-backports

add-mafro-to-video:
  user.present:
    - name: mafro
    - remove_groups: false
    - groups:
      - video

kodi-systemd-script:
  file.managed:
    - name: /etc/systemd/system/kodi.service
    - contents: |
        [Unit]
        Description = Kodi Media Center
        After = systemd-user-sessions.service network.target sound.target

        [Service]
        User = kodi
        Group = video
        Type = simple
        ExecStart = /usr/bin/xinit /usr/bin/dbus-launch --exit-with-session /usr/bin/kodi-standalone -- :0 -nolisten tcp vt7
        Restart = on-abort
        RestartSec = 5

        [Install]
        WantedBy = multi-user.target
    - user: {{ pillar.get('login_user', 'root') }}
    - mode: 744

kodi-service-enable:
  service.enabled:
    - name: kodi
    - require:
      - file: kodi-systemd-script

linux-headers:
  pkg.installed:
    - name: linux-headers-{{ salt['cmd.run']("uname -r|sed 's,[^-]*-[^-]*-,,'") }}

xwindows:
  pkg.installed:
    - names:
      - xinit
      - xserver-xorg
      - dbus-x11
      - nvidia-glx

/etc/X11/Xwrapper.config:
  file.replace:
    - pattern: "allowed_users=console"
    - repl: "allowed_users=anybody"
    - backup: false
    - require:
      - pkg: xserver-xorg

/usr/share/X11/xorg.conf.d/20-nvidia.conf:
  file.managed:
    - contents: |
        Section "Device"
            Identifier "{{ grains['host'] }}"
            Driver "nvidia"
        EndSection
    - require:
      - pkg: xserver-xorg

disable-nouveau:
  cmd.run:
    - name: echo 0 > /sys/class/vtconsole/vtcon1/bind && rmmod nouveau && rmmod ttm && rmmod drm_kms_helper && rmmod drm
    - onlyif: lsmod| grep nouveau
