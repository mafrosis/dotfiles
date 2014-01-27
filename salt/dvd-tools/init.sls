vobcopy:
  pkg.installed

dvd+rw-tools:
  pkg.installed

genisoimage:
  pkg.installed

videolan-pkgrepo:
  pkgrepo.managed:
    - humanname: VideoLAN PPA
    - name: deb http://download.videolan.org/pub/debian/stable/ /
    - file: /etc/apt/sources.list.d/videolan.list
    - key_url: http://download.videolan.org/pub/debian/videolan-apt.asc
    - require_in:
      - pkg: libdvdcss2

libdvdcss2:
  pkg.installed
