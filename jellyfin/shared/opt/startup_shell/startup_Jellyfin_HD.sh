#!/bin/bash
QPKG_NAME="Jellyfin_HD"
web_port=8096
web_ip=$(hostname -f | awk '{print $1}')

#########################################################################################
MULTIWIN="False"
[ "$(/sbin/getcfg TaskBar Enable -d False -f $HOME/.config/QNAP/QTV.conf )" == "True" ] && MULTIWIN="True"

# Single window
if [ "$MULTIWIN" == "False" ]; then
    [ -f /tmp/${QPKG_CLASS}-${QPKG_NAME}.pid ] && kill $(cat /tmp/${QPKG_CLASS}-${QPKG_NAME}.pid) && sleep 1
    xset s off -dpms
fi
#########################################################################################
if [ -x /opt/google/chrome/chrome ]; then
        CHROME_PATH=/opt/google/chrome
else
        CHROME_PATH=/opt/google/default_chrome
fi

PATH=$CHROME_PATH:$PATH
export LD_LIBRARY_PATH=$CHROME_PATH:$CHROME_PATH/lib:$LD_LIBRARY_PATH

# Private user data path
#########################################################################################
USER=$(/opt/bin/qgetuser)
[ -n "$USER" ] && [ ! -d /root/.config/chrome-user-data-dir/$QPKG_NAME/$USER ] && mkdir /root/.config/chrome-user-data-dir/$QPKG_NAME/$USER
CHROME_USER_DATA_DIR=/root/.config/chrome-user-data-dir/$QPKG_NAME/$USER
#########################################################################################
chrome --disable-translate \
       --no-first-run \
       --no-default-browser-check \
       --start-maximized \
       --disable-action-box \
       --disable-extensions \
       --no-sandbox \
       --kiosk \
       --user-data-dir=${CHROME_USER_DATA_DIR} \
       --app=http://$web_ip:$web_port/ &
PID=$!

#########################################################################################

if [ "$MULTIWIN" == "False" ]; then
    echo $PID > /tmp/${QPKG_CLASS}-${QPKG_NAME}.pid
    wait $PID
    rm /tmp/${QPKG_CLASS}-${QPKG_NAME}.pid
    [ "x$(getcfg DPMS Off -d 0 -f $HOME/.config/QNAP/QTV.conf)" != "x0" ] && xset +dpms
fi
