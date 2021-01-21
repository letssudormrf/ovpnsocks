#!/bin/sh
#export RELAY_TARGET=${RELAY_TARGET:-"squid.example.com:3128"}
mkdir -p /dev/net
mknod /dev/net/tun c 10 200
if [ ! -z "$RELAY_TARGET" ]; then
    socat tcp6-listen:8080,reuseaddr,fork tcp4:${RELAY_TARGET} &
fi
openvpn --config /tmp/${CONFIG} --script-security 2 --up /etc/openvpn/up.sh --down /etc/openvpn/down.sh
