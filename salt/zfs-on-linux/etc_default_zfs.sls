# ZoL userland configuration.

# Run `zfs mount -a` during system start?
# This should be 'no' if zfs-mountall or a systemd generator is available.
ZFS_MOUNT='{{ zfs_mount }}'

# Run `zfs unmount -a` during system stop?
# This should be 'no' on most systems.
ZFS_UNMOUNT='{{ zfs_unmount }}'

# Run `zfs share -a` during system start?
# nb: The shareiscsi, sharenfs, and sharesmb dataset properties.
ZFS_SHARE='no'

# Run `zfs unshare -a` during system stop?
ZFS_UNSHARE='no'

# Build kernel modules with the --enable-debug switch?
ZFS_DKMS_ENABLE_DEBUG='no'

# Build kernel modules with the --enable-debug-dmu-tx switch?
ZFS_DKMS_ENABLE_DEBUG_DMU_TX='no'

# Keep debugging symbols in kernel modules?
ZFS_DKMS_DISABLE_STRIP='no'

# Wait for this many seconds in the initrd pre_mountroot?
# This delays startup and should be '0' on most systems.
ZFS_INITRD_PRE_MOUNTROOT_SLEEP='0'
