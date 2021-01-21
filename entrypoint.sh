#!/bin/sh

#RELAY=${RELAY:-"1081;squid.corp.example.com:3128 1082;irc.devel.example.com:6667"}

mkdir -p /dev/net
mknod /dev/net/tun c 10 200

if [ ! -z "$RELAY" ]; then
awk -v rules="${RELAY}" 'BEGIN {
    split (rules, sections, " ");
    for (section in sections) {
        split (sections[section], rule, ";")
        print "socat tcp6-listen:" rule[1] ",reuseaddr,fork tcp4:" rule[2] " &"
    }
}' | sh
fi

openvpn --config /tmp/${CONFIG} --script-security 2 --up /etc/openvpn/up.sh --down /etc/openvpn/down.sh
