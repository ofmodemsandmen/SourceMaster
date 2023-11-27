#!/bin/sh
. /lib/functions.sh

/usr/lib/flash/ota.sh -T
ret=$(cat /tmp/flashresult)
echo "$ret" > /tmp/checkfirm
