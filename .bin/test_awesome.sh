#!/usr/bin/env bash
# If example.rc.lua is missing, make a default one.
rc_lua=$HOME/.config/awesome/rc.test.lua
test -f ${rc_lua} || /bin/cp /etc/xdg/awesome/rc.lua ${rc_lua}

# Just in case we're not running from /usr/bin
awesome=`which awesome`
xephyr=`which Xephyr`
pidof=`which pidof`
log_file="/tmp/awesome_test.log"
screen="-screen 800x600"

test -x ${awesome} || { echo "Awesome executable not found. Please install Awesome"; exit 1; }
test -x ${xephyr} || { echo "Xephyr executable not found. Please install Xephyr"; exit 1; }

function usage()
{
    cat <<USAGE
awesome_test start|stop|restart

  start    Start Xephyr with Awesome
  stop     Stop Xephyr
  restart  Reload Awesome configuration in Xephyr

USAGE
    exit 0
}

# WARNING: the following two functions expect that you only run one instance
# of Xephyr and the last launched Awesome runs in it

function awesome_pid()
{
    ${pidof} awesome | cut -d\  -f1
}

function xephyr_pid()
{
    ${pidof} Xephyr | cut -d\  -f1
}

function start()
{
    local screens=""
    local screens_count=$1
    local screen=$2
    local log_file=$3

    for i in $(seq 1 ${screens_count}) ; do
        screens="$screens $screen"
    done

    ${xephyr} -ac -br -noreset +xinerama ${screens} :1 &
    sleep 1
    DISPLAY=:1.0 ${awesome} -c ${rc_lua} &> ${log_file} &
    sleep 1
    DISPLAY=:1.0 unagi &
    sleep 1
}

function stop()
{
    local xephyr_pid=$1
    local awesome_pid=$2

    if [ -z $(xephyr_pid) ]; then
        echo "Xephyr with pid: $xephyr_pid not running"
    else
        kill $(xephyr_pid)
        echo "Xephyr with pid: $xephyr_pid successfully killed"
    fi
}

function restart()
{
    local xephyr_pid=$1
    local awesome_pid=$2

    kill -s SIGHUP ${awesome_pid}
}

[ $# -lt 1 ] && usage

case "$1" in
    start)
        if [[ $2 =~ ^[1-9]+$ ]] ; then
            screens_count=$2
        else
            screens_count=1
        fi
        echo "Starting Awesome"
        start ${screens_count} "$screen" "$log_file"
    ;;
    stop)
        echo "Stopping Awesome"
        stop $(xephyr_pid) $(awesome_pid)
    ;;
    restart)
        echo "Restarting Awesome"
        restart $(xephyr_pid) $(awesome_pid)
    ;;
    *)
        usage
    ;;
esac

exit 0
