#!/bin/sh
mkdir -p /dev/net
mknod /dev/net/tun c 10 200
openvpn --config /tmp/${CONFIG} --script-security 2 --up /etc/openvpn/up.sh --down /etc/openvpn/down.sh
