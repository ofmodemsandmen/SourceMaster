#!/bin/sh

ROOTER=/usr/lib/rooter

log() {
	modlog "CHKPIN" "$@"
}

newpin=$1
CURRMODEM=1
CPORT=$(uci get modem.modem$CURRMODEM.commport)
export PINCODE="$newpin" # Use Pin to unlock
OX=$($ROOTER/gcom/gcom-locked "/dev/ttyUSB$CPORT" "setpin.gcom" "$CURRMODEM")
sleep 5
ATCMDD="at+cpin?"
OX=$($ROOTER/gcom/gcom-locked "/dev/ttyUSB$CPORT" "run-at.gcom" "$CURRMODEM" "$ATCMDD")
RDY=$(echo "$OX" | grep "READY")
if [ -z "$RDY" ]; then # sim locked
	echo "0" > /tmp/wizpin
else
	echo "1" > /tmp/wizpin
fi