#!/bin/sh

enb=$(uci -q get flash.flash.enabled)
if [ "$enb" = "1" ]; then
	/usr/lib/flash/ota.sh &
else
	exit 0
fi