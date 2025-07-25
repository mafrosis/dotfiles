include:
  - rtorrent

extend:
  rtorrent.rc:
    file.managed:
      - context:
          move_torrent: true


{% set user = pillar.get('login_user', 'mafro') %}

# script moves completed torrents
/home/rtorrent/.local/bin:
  file.directory:
    - user: rtorrent
    - group: rtorrent
    - mode: 770
    - makedirs: true

# script moves completed torrents
/home/rtorrent/.local/bin/move-torrent.sh:
  file.managed:
    - source: salt://rtorrent/move-torrent.sh
    - user: rtorrent
    - group: rtorrent
    - mode: 774

# make script available for the login user to run
/home/{{ user }}/.local/bin/move-torrent.sh:
  file.symlink:
    - target: /home/rtorrent/.local/bin/move-torrent.sh

/var/log/move-torrent.log:
  file.managed:
    - user: rtorrent
    - group: rtorrent
    - mode: 660
    - replace: false

# ensure the rtorrent process can chown files
/etc/sudoers.d/rtorrent:
  file.managed:
    - contents: "rtorrent\tALL=(ALL)\tNOPASSWD: /bin/chown\n"
    - mode: 0440
    - require:
      - pkg: sudo
