#!/bin/bash
QPKG_NAME="Jellyfin_HD"

MULTIWIN="False"
if [ ! -f $HOME/.config/QNAP/QTV.conf -o "$(/sbin/getcfg -f $HOME/.config/QNAP/QTV.conf TaskBar Enable -d null)" == "True" ]; then
        MULTIWIN="True"
fi


if [ "$MULTIWIN" == "False" ]; then
	[ -f /tmp/${QPKG_CLASS}-${QPKG_NAME}.pid ] && kill $(cat /tmp/${QPKG_CLASS}-${QPKG_NAME}.pid) && sleep 1
else
	#killall chrome
	if [ -f /tmp/${QPKG_CLASS}-${QPKG_NAME}.pid ]; then
		pidlist=$(cat /tmp/${QPKG_CLASS}-${QPKG_NAME}.pid)
		for pid in $pidlist; do
			kill $pid &> /dev/null
		done
	fi
fi

