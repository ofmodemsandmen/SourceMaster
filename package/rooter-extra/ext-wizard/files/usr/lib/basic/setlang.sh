!/bin/sh
. /lib/functions.sh

ROOTER=/usr/lib/rooter
log() {
	modlog "SetLang" "$@"
}
	
lang=$1
uci set luci.main.lang="$lang"
uci commit luci