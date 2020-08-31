install-usbmount-deps:
  pkg.installed:
    - names:
      - build-essential
      - debhelper
      - lockfile-progs

install-usbmount:
  archive.extracted:
    - name: /tmp
    - source: https://github.com/rbrito/usbmount/archive/debian/0.0.22.tar.gz
    - source_hash: md5=7c23461fbd0222be4db9af24ea62d7f6
    - if_missing: /etc/usbmount
  cmd.wait:
    - name: dpkg-buildpackage -us -uc -b && dpkg -i /tmp/usbmount_0.0.22_all.deb
    - cwd: /tmp/usbmount-debian-0.0.22
    - watch:
      - archive: install-usbmount
    - require:
      - pkg: install-usbmount-deps
