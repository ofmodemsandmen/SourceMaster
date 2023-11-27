#!/bin/sh
. /usr/share/libubox/jshn.sh

log() {
	modlog "Flash Update : " "$@"
	#echo "$@"
}

TEST=$1

keepconfig() {
	conf=$1
	if [ -s /etc/config/$conf ]; then
		gr_backup=`grep "^/etc/config/$conf" /etc/sysupgrade.conf`
		[ -z $gr_backup ] && echo "/etc/config/$conf" >> /etc/sysupgrade.conf
	fi
}
flash() {
	slist=$1
	log "Flashing $slist"
	keepconfig zerotier
	keepconfig bwmon
	keepconfig system
	keepconfig custom
	keepconfig basic
	keepconfig wizard
	keepconfig wireless
	keepconfig travelmate
	keepconfig blacklist
	keepconfig blockport
	keepconfig gps
	keepconfig guestwifi
	keepconfig country
	keepconfig ping
	keepconfig profile
	keepconfig wireguard
	keepconfig openvpn
	keepconfig dhcp
	keepconfig system

	if [ -s /usr/lib/bwmon/data/monthly.data ]; then
		gr_backup=`grep "^/usr/lib/bwmon/data/monthly.data" /etc/sysupgrade.conf`
		[ -z $gr_backup ] && echo "/usr/lib/bwmon/data/monthly.data" >> /etc/sysupgrade.conf
	fi
	gr_backup=`grep "^/etc/shadow" /etc/sysupgrade.conf`
	[ -z $gr_backup ] && echo "/etc/shadow" >> /etc/sysupgrade.conf
	gr_backup=`grep "^/etc/hotspot" /etc/sysupgrade.conf`
	[ -z $gr_backup ] && echo "/etc/hotspot" >> /etc/sysupgrade.conf
	gr_backup=`grep "^/etc/crontabs/" /etc/sysupgrade.conf`
	[ -z $gr_backup ] && echo "/etc/crontabs/" >> /etc/sysupgrade.conf
	gr_backup=`grep "^/etc/openvpn/" /etc/sysupgrade.conf`
	[ -z $gr_backup ] && echo "/etc/openvpn/" >> /etc/sysupgrade.conf
	gr_backup=`grep "^/etc/ota" /etc/sysupgrade.conf`
	[ -z $gr_backup ] && echo "/etc/ota" >> /etc/sysupgrade.conf
	
	rm -rf /lib/upgrade/keep.d
	curl -s $slist > /tmp/firmware.bin
	if [ $? = '0' ]; then
		sysupgrade -T /tmp/firmware.bin
		fault_code="$?"
		if [ "$fault_code" != "0" ]; then
			log "Flashing Error"
			echo "1" > /tmp/flashresult
		else
			log "Flash Good"
			if [ "$TEST" != "-T" ]; then
				uci set flash.flash.last="$img"
				dt=$(date +%c)
				uci set flash.flash.date="$dt"
				uci commit flash
				keepconfig flash
				/usr/lib/flash/sys.sh &
				echo "0" > /tmp/flashresult
				exit 0
			else
				uci set flash.flash.lastchk="$img"
				uci commit flash
			fi
			echo "0" > /tmp/flashresult
		fi
	else
		log "Router Firmware File Missing"
		echo "2" > /tmp/flashresult
	fi
}

ip=$(uci -q get otaconfig.ota.ip)
server="ftp://$ip//files/OTA/"
mak=$(cat /tmp/sysinfo/model)
model=$(echo $mak | tr " " "-")
#model="WorldTraveller-Speed-V2"
#model="WorldTraveller-5G"
#model="WorldTraveller"
#model="WorldTraveller-Ruggedized"
full=0
if [ -e /etc/config/mwan3 ]; then
	full=1
fi
source /etc/codename
fdate=$(echo $CODENAME" " | cut -d_ -f2)
fdate=$(echo $fdate | tr "-" "0")
serverx=$server"/"$model
lang=$(uci -q get luci.main.modlang)
if [ "$model" = "WorldTraveller" ]; then
	mak=$(cat /tmp/sysinfo/board_name)
	rmod=$(echo "$mak" | grep "wg1602")
	if [ ! -z "$rmod" ]; then
		serverx=$server"/WorldTraveller1602"
	fi
	rmod=$(echo "$mak" | grep "oolite")
	if [ ! -z "$rmod" ]; then
		serverx=$server"/WorldTraveller826Q"
	fi
fi

flist=$(curl -s -l $serverx"/")
if [ ! -z "$flist" ]; then
	img=""
	idate=""
	for mlist in $flist; do
		mmod=$(echo "$mlist" | grep "$model")
		if [ ! -z "$mmod" ]; then
			if [ "$full" -eq 0 ]; then
				mwan=$(echo "$mlist" | grep "full")
				if [ -z "$mwan" ]; then
					gdate=$(echo "$mlist" | sed "s/-GO/_/g")
					gdate=$(echo $gdate | cut -d_ -f2)
					gdate=${gdate:0:10}
					gdate=$(echo $gdate | tr "-" "0")
					fflg=0
					flang=$(echo "$mlist" | grep "English")
					if [ "$flang" = "" -a "$lang" = "de" ]; then
						fflg=1
					else
						if [ "$flang" != "" -a "$lang" = "en" ]; then
							fflg=1
						fi
					fi
					if [ "$fflg" -eq 1 ]; then
						if [ "$fdate" -lt "$gdate" ]; then
							if [ ! -z "$idate" ]; then
								if [ "$idate" -lt "$gdate" ]; then
									img=$mlist
									idate=$gdate
								fi
							else
								img=$mlist
								idate=$gdate
							fi
						fi
					fi
				fi
			else
				mwan=$(echo "$mlist" | grep "full")
				if [ ! -z "$mwan" ]; then
					gdate=$(echo "$mlist" | sed "s/-GO/_/g")
					gdate=$(echo $gdate | cut -d_ -f2)
					gdate=${gdate:0:10}
					gdate=$(echo $gdate | tr "-" "0")
					fflg=0
					flang=$(echo "$mlist" | grep "English")
					if [ "$flang" = "" -a "$lang" = "de" ]; then
						fflg=1
					else
						if [ "$flang" != "" -a "$lang" = "en" ]; then
							fflg=1
						fi
					fi
					if [ "$fflg" -eq 1 ]; then
						if [ "$fdate" -lt "$gdate" ]; then
							if [ ! -z "$idate" ]; then
								if [ "$idate" -lt "$gdate" ]; then
									img=$mlist
									idate=$gdate
								fi
							else
								img=$mlist
								idate=$gdate
							fi
						fi
					fi
				fi
			fi

		fi
	done	
	if [ ! -z "$img" ]; then
		flash $serverx"/"$img
	else
		log "Already Up to Date"
		echo "3" > /tmp/flashresult
	fi
else
	log "Already Up to Date"
	echo "3" > /tmp/flashresult
fi