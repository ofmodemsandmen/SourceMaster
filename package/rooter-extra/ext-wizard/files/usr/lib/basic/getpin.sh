#!/bin/sh

log() {
	modlog "GetPIN" "$@"
}

pin=$(uci -q get profile.simpin.pin)
if [ -z "$pin" ]; then
	pin="---"
fi
echo "$pin" > /tmp/wizpin
