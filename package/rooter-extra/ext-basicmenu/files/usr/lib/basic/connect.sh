#!/bin/sh
. /lib/functions.sh

log() {
	wifilog "Check Connect" "$@"
}

freq=$(uci -q get basic.basic.freq)
if [ -z $freq ]; then
	exit 0
fi
ssid=$(uci -q get basic.basic.ssid)
if [ -z $ssid ]; then
	exit 0
fi
psk=$(uci -q get basic.basic.psk)
if [ -z $psk ]; then
	exit 0
fi
pass=$(uci -q get basic.basic.password)

/usr/lib/hotspot/enable.sh 0
uci set travelmate.global.trm_auto="0"
uci set travelmate.global.freq=$freq
uci set travelmate.global.trm_enabled=1
uci commit travelmate
echo "$ssid|$psk|$pass"  > /tmp/hotman
hkillall travelmate.sh
/usr/lib/hotspot/travelmate.sh &
