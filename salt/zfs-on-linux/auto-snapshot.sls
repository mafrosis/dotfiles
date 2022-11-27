zfs-auto-snapshot:
  pkg.installed

# No weekly snapshots
/etc/cron.weekly/zfs-auto-snapshot:
  file.absent

# 15m retain 4
/etc/cron.d/zfs-auto-snapshot:
  file.managed:
    - contents: |
        PATH="/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin"
        */15 * * * * root zfs-auto-snapshot --quiet --syslog --label=frequent --keep=4 //

# Hourly retain 8
/etc/cron.hourly/zfs-auto-snapshot:
  file.managed:
    - contents: |
        #!/bin/sh
        exec zfs-auto-snapshot --quiet --syslog --label=hourly --keep=8 //

# Daily retain 31
/etc/cron.daily/zfs-auto-snapshot:
  file.managed:
    - contents: |
        #!/bin/sh
        exec zfs-auto-snapshot --quiet --syslog --label=daily --keep=31 //

# Monthly retain 6
/etc/cron.monthly/zfs-auto-snapshot:
  file.managed:
    - contents: |
        #!/bin/sh
        exec zfs-auto-snapshot --quiet --syslog --label=daily --keep=6 //
