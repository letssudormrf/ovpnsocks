#!/bin/sh
openvpn --config /tmp/${CONFIG} --script-security 2 --up /etc/openvpn/up.sh --down /etc/openvpn/down.sh
