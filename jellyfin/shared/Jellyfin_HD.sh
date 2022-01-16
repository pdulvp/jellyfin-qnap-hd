#!/bin/sh
CONF=/etc/config/qpkg.conf
QPKG_NAME="Jellyfin_HD"

case "$1" in
  start)
    ENABLED=$(/sbin/getcfg $QPKG_NAME Enable -u -d FALSE -f $CONF)
    if [ "$ENABLED" != "TRUE" ]; then
        echo "$QPKG_NAME is disabled."
        exit 1
    fi
    : ADD START ACTIONS HERE
	[ -p /tmp/HD_Station.ServicePipe ] && echo "$QPKG_NAME start" > /tmp/HD_Station.ServicePipe
    ;;

  stop)
    : ADD STOP ACTIONS HERE
	[ -p /tmp/HD_Station.ServicePipe ] && echo "$QPKG_NAME stop" > /tmp/HD_Station.ServicePipe &
    ;;

  restart)
    $0 stop
    $0 start
    ;;

  *)
    echo "Usage: $0 {start|stop|restart}"
    exit 1
esac

exit 0
