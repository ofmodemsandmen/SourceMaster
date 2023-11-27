#!/bin/sh
. /lib/functions.sh

log() {
	modlog "GetSSID" "$@"
}

cnt_radio() {
	let CNT=$CNT+1
}

CNT=0
config_load wireless
config_foreach cnt_radio wifi-device

uci set wizard.wizard.radionum=$CNT

let ct=$CNT-1
for i in $(seq 0 $ct)
do
	ssid=$(uci -q get wireless.default_radio$i.ssid)
	uci set wizard.wizard.ssid$i="$ssid"
	pass=$(uci -q get wireless.default_radio$i.key)
	uci set wizard.wizard.password$i="$pass"
done
znam=$(uci -q get system.@system[0].zonename)
uci set wizard.wizard.zone="$znam"
uci set wizard.basic.wizard="1"
uci commit wizard
