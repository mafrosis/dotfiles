include:
  - zfs-on-linux.auto-snapshot


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

zfs.target:
  service.enabled

zfs-import.target:
  service.enabled

zfs-import-cache.service:
  service.enabled

zfs-mount.service:
  service.enabled

# Samba/NFS not handled by ZFS
zfs-share.service:
  service.disabled
