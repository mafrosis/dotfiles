#!/bin/bash
### BEGIN INIT INFO
# Provides:          rtorrent_autostart
# Required-Start:    $local_fs $remote_fs $network $syslog $netdaemons
# Required-Stop:     $local_fs $remote_fs
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: rtorrent script using tmux
# Description:       rtorrent script using tmux
### END INIT INFO

# system user to run as (can only use one)
user="rtorrent"

# system user to run as # not implemented, see d_start for beginning implementation
# group=$(id -ng "$user")

# default directory for screen, needs to be an absolute path
base=$(su -c 'echo $HOME' $user)

# the full path to the filename where you store your rtorrent configuration
config="/home/rtorrent/.rtorrent.rc"

# options to pass to rtorrent, dont read config from $HOME; load alternate
options="-n -O import=$config"


PATH=/usr/bin:/usr/local/bin:/usr/local/sbin:/sbin:/bin:/usr/sbin
DESC="rtorrent"
NAME=rtorrent
DAEMON=$NAME
SCRIPTNAME=/etc/init.d/$NAME

checkcnfg() {
	if [ -z "$(which $DAEMON)" ] ; then
        echo "Cannot find $DAEMON binary in PATH: $PATH"
        exit 3
    fi
    if ! [ -r "$config" ] ; then
        echo "Cannot find readable config $config. Check that it is there and permissions are appropriate"
        exit 3
    fi
    session=$(getsession "$config")
    if ! [ -d "$session" ] ; then
        echo "Cannot find readable session directory $session from config $config. Check permissions"
        exit 3
    fi
}

d_start() {
    [ -d "$base" ] && cd "$base"
    stty stop undef && stty start undef
	sudo -u $user -g $user tmux new-session -s $NAME -d "$DAEMON $options"
}

d_stop() {
    session=$(getsession "$config")
    if ! [ -s ${session}/rtorrent.lock ] ; then
        return
    fi
    pid=$(cat ${session}/rtorrent.lock | awk -F: '{print($2)}' | sed "s/[^0-9]//g")
    # make sure the pid doesn't belong to another process
    if ps -A | grep -sq ${pid}.*rtorrent ; then
        kill -s INT ${pid}
    fi
}

getsession() {
    session=$(cat "$1" | grep "^[[:space:]]*session[[:space:]]*=" | sed "s/^[[:space:]]*session[[:space:]]*=[[:space:]]*//" )
    echo $session
}

checkcnfg

case "$1" in
    start)
        echo -n "Starting $DESC: $NAME"
        d_start
        echo "."
        ;;
    stop)
        echo -n "Stopping $DESC: $NAME"
        d_stop
        echo "."
        ;;
    restart|force-reload)
        echo -n "Restarting $DESC: $NAME"
        d_stop
        sleep 1
        d_start
        echo "."
        ;;
    *)
        echo "Usage: $SCRIPTNAME {start|stop|restart|force-reload}" >&2
        exit 1
        ;;
esac

exit 0
