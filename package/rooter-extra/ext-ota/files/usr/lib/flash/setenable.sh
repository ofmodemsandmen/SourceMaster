#!/bin/sh
. /lib/functions.sh

set=$1

uci set flash.flash.enabled="$set"
uci commit flash