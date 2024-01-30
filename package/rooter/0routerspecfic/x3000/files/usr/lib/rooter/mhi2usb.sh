#!/bin/sh

ROOTER=/usr/lib/rooter

CURRMODEM=$1
CPORT=$(uci -q get modem.modem$CURRMODEM.commport)
ATCMDD="ati"
OX=$($ROOTER/gcom/gcom-locked "/dev/ttyUSB$CPORT" "run-at.gcom" "$CURRMODEM" "$ATCMDD")

revs=$(echo $OX | grep -m 1 'Revision:')
if [ ! -z "$revs" ]; then
	revs=$(echo $revs" " | tr " " ",")
	mfirm=$(echo $revs | cut -d, -f5)
fi
rm -f /tmp/mhiusb
tousb="0"
da=$(echo "$mfirm" | grep "AA")
if [ ! -z "$da" ]; then
	#ATCMDD="AT+QUIMSLOT=1"
	#OX=$($ROOTER/gcom/gcom-locked "/dev/ttyUSB$CPORT" "run-at.gcom" "$CURRMODEM" "$ATCMDD")
	ATCMDD="AT+QCFG=\"data_interface\""
	OX=$($ROOTER/gcom/gcom-locked "/dev/ttyUSB$CPORT" "run-at.gcom" "$CURRMODEM" "$ATCMDD")
	usb=$(echo "$OX" | grep "1")
	if [ ! -z "$usb" ]; then
		ATCMDD="AT+QCFG=\"data_interface\",0,0"
		OX=$($ROOTER/gcom/gcom-locked "/dev/ttyUSB$CPORT" "run-at.gcom" "$CURRMODEM" "$ATCMDD")
		echo $OX
		ok=$(echo "$OX" | grep "OK")
		if [ ! -z "$ok" ]; then
			$ROOTER/luci/restart.sh $CURRMODEM 11
		else
			tousb="1"
		fi
	fi
else
	tousb="1"
fi
if [ "$tousb" = "1" ]; then
	echo "0" > /tmp/mhiusb
	if [ -e $ROOTER/modem-led.sh ]; then
		$ROOTER/modem-led.sh $CURRMODEM 4
	fi
fi