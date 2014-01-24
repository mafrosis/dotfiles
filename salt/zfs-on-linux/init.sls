zfs-kernel-headers:
  pkg.installed:
    - name: linux-headers-{{ grains["kernelrelease"] }}

{% if grains['os'] == "Debian" %}

zol-pkgrepo:
  pkgrepo.managed:
    - humanname: ZOL
    - name: deb http://archive.zfsonlinux.org/debian wheezy main
    - file: /etc/apt/sources.list.d/zfsonlinux.list
    - key_url: salt://zfs-on-linux/zfsonlinux.gpg
    - require_in:
      - pkg: zol-install

zol-pinning:
  file.managed:
    - name: /etc/apt/preferences.d/pin-zfsonlinux
    - contents: "Package: *\nPin: release o=archive.zfsonlinux.org\nPin-Priority: 1001"

zol-install:
  pkg.installed:
    - name: debian-zfs
    - require:
      - file: zol-pinning
      - pkg: zfs-kernel-headers

/etc/default/zfs.orig:
  file.managed:
    - source: salt://zfs-on-linux/etc_default_zfs.orig

/etc/default/zfs:
  file.managed:
    - source: salt://zfs-on-linux/etc_default_zfs.sls
    - template: jinja
    - defaults:
        zfs_mount: 'yes'
        zfs_unmount: 'yes'

{% elif grains['os'] == "Ubuntu" %}

zol-pkgrepo:
  pkgrepo.managed:
    - humanname: ZOL
    - name: deb http://ppa.launchpad.net/zfs-native/stable/ubuntu wheezy main
    - file: /etc/apt/sources.list.d/zfs-native.list
    - keyid: F6B0FC61
    - keyserver: keyserver.ubuntu.com
    - require_in:
      - pkg: zol-install

zol-install:
  pkg.installed:
    - name: ubuntu-zfs
    - require:
      - pkg: zfs-kernel-headers

{% endif %}
