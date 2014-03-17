# Port range to use for listening
port_range = 29150-29159

# Global upload and download rate in KiB. "0" for unlimited
download_rate = {{ download_rate }}
upload_rate = {{ upload_rate }}

encoding_list = UTF-8

# enable SGCI gateway for external control of rtorrent
scgi_port = 127.0.0.1:5000

# Default directory to save the downloaded torrents
directory = {{ download_dir }}

# Default session directory. Make sure you don't run multiple instance
# of rtorrent using the same session directory
session = /home/rtorrent/session

# allow owner & group full access to files; no access to other
system.umask.set = 0007

# move torrents on download finish
system.method.set_key = event.download.finished,check_complete,"execute=/home/rtorrent/bin/move-torrent.sh,$d.get_custom1=,$d.get_base_path="
