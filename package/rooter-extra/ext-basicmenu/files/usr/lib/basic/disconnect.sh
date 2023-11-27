#!/bin/sh
. /lib/functions.sh

log() {
	wifilog "Disconnect" "$@"
}

#tdis=$(uci -q get travelmate.global.trm_enabled)
#if [ "$tdis" != "0" ]; then
log "Basic Disconnect"
	/usr/lib/hotspot/enable.sh 0
#fi
