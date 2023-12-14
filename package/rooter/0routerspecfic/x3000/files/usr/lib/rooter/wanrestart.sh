#!/bin/sh

log() {
	modlog "WAN Restart" "$@"
}

sleep 60
log "Restart WAN"
ifup wan
#ubus call network.interface.wan up
#ubus call network reload
