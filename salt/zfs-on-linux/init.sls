include:
  - zfs-on-linux.auto-snapshot


{% if grains['os'] == 'Debian' %}

zfs-kernel-headers:
  pkg.installed:
    - name: linux-headers-{{ grains['kernelrelease'] }}

zol-install:
  pkg.installed:
    - names:
      - zfs-dkms
      - zfsutils-linux
    - require:
      - pkg: zfs-kernel-headers

{% elif grains['oscodename'] == 'xenial' %}

zol-install:
  pkg.installed:
    - name: zfsutils-linux

{% endif %}


{% if pillar.get('zpool_import', false) %}

zpool-import-all:
  cmd.run:
    - name: zpool import -a -N
    - onlyif: zfs list 2>&1 | grep 'no datasets available'
    - require:
      - pkg: zol-install

zpool-mount-all:
  cmd.run:
    - name: zfs mount -a
    - require:
      - cmd: zpool-import-all
    - order: 1

{% endif %}
