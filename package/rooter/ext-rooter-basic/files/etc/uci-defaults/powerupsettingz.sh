#!/bin/sh

uci set network.globals.packet_steering='1'
uci commit network
/etc/init.d/network restart
uci set firewall.@defaults[0].flow_offloading='1'
uci set firewall.@defaults[0].flow_offloading_hw='1'
uci commit firewall
/etc/init.d/firewall restart

while IFS='' read -r a; do
    echo "${a//snapshots/releases/23.05.5}"
done < /etc/opkg/distfeeds.conf > /tmp/distfeeds.conf.t
mv /tmp/distfeeds.conf.t /etc/opkg/distfeeds.conf