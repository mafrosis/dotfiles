include:
  - zfs-on-linux.auto-snapshot


linux-headers-amd64:
  pkg.installed

zol-install:
  pkg.installed:
    - names:
      - zfs-dkms
      - zfsutils-linux
    - require:
      - pkg: linux-headers-amd64

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
