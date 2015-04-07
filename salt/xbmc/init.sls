include:
  - debian-repos.contrib
  - debian-repos.nonfree

xbmc:
  pkg.installed

add-mafro-to-video:
  user.present:
    - name: mafro
    - remove_groups: false
    - groups:
      - video

xbmc-init-script:
  file.managed:
    - name: /etc/init.d/xbmc
    - source: salt://xbmc/xbmc.init
    - user: {{ pillar.get('login_user', 'root') }}
    - mode: 744

linux-headers:
  pkg.installed:
    - name: linux-headers-{{ salt['cmd.run']("uname -r|sed 's,[^-]*-[^-]*-,,'") }}

xwindows:
  pkg.installed:
    - names:
      - xinit
      - xserver-xorg
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
