#!/bin/sh
. /lib/functions.sh

ROOTER=/usr/lib/rooter
log() {
	modlog "SetWizard" "$@"
}
	
act=$1

action=$(echo "$act" | cut -d[ -f1)
first=$(echo "$act" | cut -d[ -f2)
second=$(echo "$act" | cut -d[ -f3)

if [ "$action" = "1" ]; then
	if [ -z "$first" ]; then
		exit 0
	fi
	passw=$first
	echo -e "$passw\n$passw" | passwd root
	exit 0
fi

if [ "$action" = "2" ]; then
	ssid="$first"
	passw="$second"
	chan=$(uci -q get wireless.radio0.channel)
	if [ "$chan" -lt 20 ]; then
		uci set wireless.default_radio0.ssid="$ssid"
		uci set wireless.default_radio0.key="$passw"
	else
		uci set wireless.default_radio1.ssid="$ssid"
		uci set wireless.default_radio1.key="$passw"
	fi
	uci commit wireless
	wifi up
	exit 0
fi

if [ "$action" = "3" ]; then
	ssid="$first"
	passw="$second"
	chan=$(uci -q get wireless.radio0.channel)
	if [ "$chan" -lt 20 ]; then
		uci set wireless.default_radio1.ssid="$ssid"
		uci set wireless.default_radio1.key="$passw"
	else
		uci set wireless.default_radio0.ssid="$ssid"
		uci set wireless.default_radio0.key="$passw"
	fi
	uci commit wireless
	wifi up
	exit 0
fi

if [ "$action" = "4" ]; then
	cpin=$(uci -q get profile.simpin.pin)
	if [ "$first" = "$cpin" ]; then
		exit 0
	fi
	uci set profile.simpin.pin="$first"
	uci commit profile
	/usr/lib/rooter/luci/restart.sh 1 11 &
	uci set wizard.basic.detect="0"
	uci commit wizard
	exit 0
fi

if [ "$action" = "5" ]; then
	wiz=$(uci -q get wizard.basic.wizard)
	if [ "$wiz" = "1" ]; then
		/usr/lib/rooter/luci/restart.sh 1 11 &
	fi
	uci set wizard.basic.wizard="0"
	uci set wizard.basic.detect="0"
	uci commit wizard
	exit 0
fi

if [ "$action" = "6" ]; then
	name="$first"
	zone="$second"
	uci set system.@system[0].zonename="$name"
	uci set system.@system[0].timezone="$zone"
	uci commit system
	/etc/init.d/system restart
	exit 0
fi
