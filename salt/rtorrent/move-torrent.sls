include:
  - rtorrent

extend:
  rtorrent.rc:
    file.managed:
      - context:
          move_torrent: true


# script moves completed torrents
/home/rtorrent/bin:
  file.directory:
    - user: rtorrent
    - group: rtorrent
    - mode: 700

# script moves completed torrents
/home/rtorrent/bin/move-torrent.sh:
  file.managed:
    - source: salt://rtorrent/move-torrent.sh
    - user: rtorrent
    - group: rtorrent
    - mode: 774

# make script available for the login user to run
/home/{{ pillar['login_user'] }}/bin/move-torrent.sh:
  file.symlink:
    - target: /home/rtorrent/bin/move-torrent.sh

/var/log/move-torrent.log:
  file.managed:
    - user: rtorrent
    - group: rtorrent
    - mode: 660

# ensure the rtorrent process can chown files
/etc/sudoers.d/rtorrent:
  file.managed:
    - contents: "rtorrent\tALL=(ALL)\tNOPASSWD: /bin/chown\n"
    - mode: 0440
    - require:
      - pkg: sudo
