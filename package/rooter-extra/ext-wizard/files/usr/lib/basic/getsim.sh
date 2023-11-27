#!/bin/sh
. /lib/functions.sh

ROOTER=/usr/lib/rooter
log() {
	modlog "GetSIM" "$@"
}
	
rest=$1
if [ "$rest" = "1" ]; then
	/usr/lib/rooter/luci/restart.sh 1 11 &
	exit 0
fi
if [ "$rest" = "2" ]; then
	sleep 30
fi	
CURRMODEM=1
PRES=$(uci get modem.modem$CURRMODEM.empty)
if [ "$PRES" = "1" ]; then
	sleep 10
	PRES=$(uci get modem.modem$CURRMODEM.empty)
	if [ "$PRES" = "1" ]; then
		uci set wizard.wizard.simpresent="2"
		uci set wizard.wizard.simpin="0"
		uci commit wizard
		exit 0
	fi
fi
cntr=0
while [ true ]; do
	CPORT=$(uci get modem.modem$CURRMODEM.commport)
	if [ ! -z "$CPORT" ]; then
		break
	fi
	let cntr=$cntr+1
	if [ "$cntr" -gt 9 ]; then
		uci set wizard.wizard.simpresent="2"
		uci set wizard.wizard.simpin="0"
		uci commit wizard
		exit 0
	fi
	sleep 5
done

ATCMDD="at+cpin?"
OX=$($ROOTER/gcom/gcom-locked "/dev/ttyUSB$CPORT" "run-at.gcom" "$CURRMODEM" "$ATCMDD")
ERR=$(echo "$OX" | grep "ERROR")
if [ ! -z "$ERR" ]; then # No SIM
	uci set wizard.wizard.simpresent="0"
	uci set wizard.wizard.simpin="0"
	uci commit wizard
	exit 0
fi
uci set wizard.wizard.simpresent="1"
RDY=$(echo "$OX" | grep "READY")
if [ -z "$RDY" ]; then # SIM Locked
	uci set wizard.wizard.simpin="1"
else
	uci set wizard.wizard.simpin="0"
fi
uci commit wizard
