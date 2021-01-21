#!/bin/sh

#RELAY_TCP=${RELAY_TCP:-"1081;squid.corp.example.com:3128 1082;irc.devel.example.com:6667"}
#RELAY_UDP=${RELAY_UDP:-"1081;squid.corp.example.com:3128 1082;irc.devel.example.com:6667"}

mkdir -p /dev/net
mknod /dev/net/tun c 10 200

if [ ! -z "$RELAY_TCP" ]; then
awk -v rules="${RELAY_TCP}" 'BEGIN {
    split (rules, sections, " ");
    for (section in sections) {
        split (sections[section], rule, ";")
        print "socat tcp6-listen:" rule[1] ",reuseaddr,fork tcp4:" rule[2] " &"
    }
}' | sh
fi

if [ ! -z "$RELAY_UDP" ]; then
awk -v rules="${RELAY_UDP}" 'BEGIN {
    split (rules, sections, " ");
    for (section in sections) {
        split (sections[section], rule, ";")
        print "socat udp6-listen:" rule[1] ",reuseaddr,fork udp4:" rule[2] " &"
    }
}' | sh
fi

openvpn --config /tmp/${CONFIG} --script-security 2 --up /etc/openvpn/up.sh --down /etc/openvpn/down.sh
