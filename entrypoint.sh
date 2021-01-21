#!/bin/sh
mkdir -p /dev/net
mknod /dev/net/tun c 10 200
#socat tcp6-listen:8080,reuseaddr,fork tcp4:squid.example.com:3128
openvpn --config /tmp/${CONFIG} --script-security 2 --up /etc/openvpn/up.sh --down /etc/openvpn/down.sh
