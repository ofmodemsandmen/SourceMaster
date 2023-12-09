#!/bin/sh

log() {
	modlog "modem-led " "$@"
}

CURRMODEM=$1
COMMD=$2

	case $COMMD in
		"0" )
			uci -q delete system.led_4g
			uci commit system
			/etc/init.d/led restart
			echo none > /sys/class/leds/amber:5g/trigger
			echo 0  > /sys/class/leds/amber:5g/brightness
			;;
		"1" )
			echo timer > /sys/class/leds/amber:5g/trigger
			echo 500  > /sys/class/leds/amber:5g/delay_on
			echo 500  > /sys/class/leds/amber:5g/delay_off
			;;
		"2" )
			echo timer > /sys/class/leds/amber:5g/trigger
			echo 200  > /sys/class/leds/amber:5g/delay_on
			echo 200  > /sys/class/leds/amber:5g/delay_off
			;;
		"3" )
			echo none > /sys/class/leds/amber:5g/trigger
			echo 0  > /sys/class/leds/amber:5g/brightness
			INTER=$(uci get modem.modem$CURRMODEM.interface)
			uci set system.led_4g=led
			uci set system.led_4g.name="4g"
			uci set system.led_4g.sysfs="green:5g"
			uci set system.led_4g.trigger="netdev"
			uci set system.led_4g.dev="$INTER"
			uci set system.led_4g.mode="link tx rx"
			uci commit system
			/etc/init.d/led restart
			;;
	esac
