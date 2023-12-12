#!/bin/sh

log() {
	modlog "modem-led " "$@"
}

CURRMODEM=$1
COMMD=$2

	case $COMMD in
		"0" )
			echo none > /sys/class/leds/white:cellular-1/trigger
			echo 0  > /sys/class/leds/white:cellular-1/brightness
			echo none > /sys/class/leds/white:cellular-2/trigger
			echo 0  > /sys/class/leds/white:cellular-2/brightness
			echo none > /sys/class/leds/white:cellular-3/trigger
			echo 0  > /sys/class/leds/white:cellular-3/brightness
			echo none > /sys/class/leds/white:cellular-4/trigger
			echo 0  > /sys/class/leds/white:cellular-4/brightness
			;;
		"1" )
			echo timer > /sys/class/leds/white:cellular-1/trigger
			echo 500  > /sys/class/leds/white:cellular-1/delay_on
			echo 500  > /sys/class/leds/white:cellular-1/delay_off
			echo timer > /sys/class/leds/white:cellular-2/trigger
			echo 500  > /sys/class/leds/white:cellular-2/delay_on
			echo 500  > /sys/class/leds/white:cellular-2/delay_off
			echo timer > /sys/class/leds/white:cellular-3/trigger
			echo 500  > /sys/class/leds/white:cellular-3/delay_on
			echo 500  > /sys/class/leds/white:cellular-3/delay_off
			echo timer > /sys/class/leds/white:cellular-4/trigger
			echo 500  > /sys/class/leds/white:cellular-4/delay_on
			echo 500  > /sys/class/leds/white:cellular-4/delay_off
			;;
		"2" )
			echo timer > /sys/class/leds/white:cellular-1/trigger
			echo 200  > /sys/class/leds/white:cellular-1/delay_on
			echo 200  > /sys/class/leds/white:cellular-1/delay_off
			echo timer > /sys/class/leds/white:cellular-2/trigger
			echo 200  > /sys/class/leds/white:cellular-2/delay_on
			echo 200  > /sys/class/leds/white:cellular-2/delay_off
			echo timer > /sys/class/leds/white:cellular-3/trigger
			echo 200  > /sys/class/leds/white:cellular-3/delay_on
			echo 200  > /sys/class/leds/white:cellular-3/delay_off
			echo timer > /sys/class/leds/white:cellular-4/trigger
			echo 200  > /sys/class/leds/white:cellular-4/delay_on
			echo 200  > /sys/class/leds/white:cellular-4/delay_off
			;;
		"3" )
			echo none > /sys/class/leds/white:cellular-1/trigger
			echo 1  > /sys/class/leds/white:cellular-1/brightness
			echo none > /sys/class/leds/white:cellular-2/trigger
			echo 1  > /sys/class/leds/white:cellular-2/brightness
			echo none > /sys/class/leds/white:cellular-3/trigger
			echo 1  > /sys/class/leds/white:cellular-3/brightness
			echo none > /sys/class/leds/white:cellular-4/trigger
			echo 1  > /sys/class/leds/white:cellular-4/brightness
			;;
		"5" )
			echo timer > /sys/class/leds/white:cellular-1/trigger
			echo 200  > /sys/class/leds/white:cellular-1/delay_on
			echo 200  > /sys/class/leds/white:cellular-1/delay_off
			echo none > /sys/class/leds/white:cellular-2/trigger
			echo 0  > /sys/class/leds/white:cellular-2/brightness
			echo none > /sys/class/leds/white:cellular-3/trigger
			echo 0  > /sys/class/leds/white:cellular-3/brightness
			echo timer > /sys/class/leds/white:cellular-4/trigger
			echo 200  > /sys/class/leds/white:cellular-4/delay_on
			echo 200  > /sys/class/leds/white:cellular-4/delay_off
			;;
	esac
