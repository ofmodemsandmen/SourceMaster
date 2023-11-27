#!/bin/sh

ROOTER=/usr/lib/rooter
ROOTER_LINK="/tmp/links"

log() {
	modlog "Autoapn" "$@"
}

sortapn() {
	while IFS= read -r line; do
		read -r line
		read -r line
		read -r line
		cgd=$line
		break
	done < /tmp/simmcc
	qapn=$(echo "$cgd" | cut -d, -f3)
	apn=$(echo "$qapn" | tr -d \" )

	match=""
	isplist=$( cat /tmp/apndata)
	for isp in $isplist 
	do
		mapn=$(echo "$isp" | cut -d, -f2)
		if [ "$mapn" = "$apn" ]; then
			match="$isp"
			break
		fi
	done
	if [ ! -z "$match" ]; then
		list="$match "
		for isp in $isplist 
		do
			if [ "$isp" != "$match" ]; then
				list=$list$isp" "
			fi
		done
		echo "$list" > /tmp/apndata
	fi
}

rm -f /tmp/apndata
sel=$(uci -q get country.general.selected)
if [ "$sel" = "1" ]; then
	exit 0
fi
apnmcc=$(uci -q get profile.disable.mccapn)
if [ "$apnmcc" != "1" ]; then
	exit 0
fi
CURRMODEM=$1
CPORT=$(uci get modem.modem$CURRMODEM.commport)
rm -f /tmp/apndata
mccfile="/tmp/simmcc"
imsi=$(uci -q get modem.modem$CURRMODEM.imsi)
mcc6=${imsi:0:6}
mcc5=${imsi:0:5}
echo "$mcc6" > $mccfile
echo "$mcc5" >> $mccfile
ATCMDD="at+cgdcont?"
OX=$($ROOTER/gcom/gcom-locked "/dev/ttyUSB$CPORT" "run-at.gcom" "$CURRMODEM" "$ATCMDD")
echo "$OX" >> $mccfile

while IFS= read -r line; do
	mcc6=$line
	read -r line
	mcc5=$line
	read -r line
	read -r line
	cgd=$line
	break
done < $mccfile

tmp=$(echo "$cgd" | cut -d, -f3 )
apn=$(echo "$tmp" | tr -d '"')
mcc=${mcc6:0:3}
mnc6=${mcc6:3:3}
mnc5=${mcc5:3:2}

flg="0"
fnd="0"
while IFS= read -r line; do
	if [ "$flg" = "0" ]; then
		flg="1"
	else
		ldata=$line
		ldata=$(echo "$ldata" | tr "|" "!")
		tmp=$(echo "$ldata" | cut -d! -f1 )
		cmcc=$(echo "$tmp" | cut -d, -f2 )
		if [ "$mcc" = "$cmcc" ]; then
			fnd="1"
			break
		fi
	fi
done < /usr/lib/country/mccdata

apndata=""
cfnd="0"
if [ "$fnd" = "1" ]; then
	tmp=$(echo "$ldata" | cut -d! -f2 )
	if [ "$tmp" != "?" ]; then
		res="${ldata//[^!]}"
		sz=$(echo "${#res}")
		for i in $(seq 1 $sz);
		do
			let ct=$i+1
			ispdata=$(echo "$ldata" | cut -d! -f$ct )
			mnc=$(echo "$ispdata" | cut -d, -f1 )
			capn=$(echo "$ispdata" | cut -d, -f2 )
			cname=$(echo "$ispdata" | cut -d, -f3 )
			cuser=$(echo "$ispdata" | cut -d, -f4 )
			if [ "$cuser" = "~" ]; then
				cuser="NIL"
			fi
			ccid=$(echo "$ispdata" | cut -d, -f5 )
			cpass=$(echo "$ispdata" | cut -d, -f6 )
			if [ "$cpass" = "~" ]; then
				cpass="NIL"
			fi
			cauth=$(echo "$ispdata" | cut -d, -f7)
			if [ "$cauth" = "~" ]; then
				cauth="0"
			fi
			cpdp=$(echo "$ispdata" | cut -d, -f8)
			if [ "$cpdp" = "~" ]; then
				cpdp="IPV4V6"
			else
				case $cpdp in
					"1" )
					cpdp="IP"
					;;
					"2" )
					cpdp="IPV6"
					;;
					"3" )
					cpdp="IPV4V6"
					;;
					"0" )
					cpdp="IPV4V6"
					;;
				esac
			fi
			size=${#mnc} 
			if [ "$size" = "3" ]; then
				cmnc=$mnc6
			else
				cmnc=$mnc5
			fi
			
			if [ "$mnc" = "$cmnc" ]; then
				apndata=$apndata"$mcc","$capn","Default","$cuser","$ccid","$cpass","$cauth","$cpdp "
				cfnd="1"
			fi
		done
		if [ "$cfnd" = "1" ]; then
			echo "$apndata" > /tmp/apndata
			sel=$(uci -q get profile.disable.sort)
			if [ "$sel" = "1" ]; then
				sortapn
			fi
		fi
	fi
fi