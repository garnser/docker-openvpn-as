#!/usr/bin/env bash

# Remove old PID
if [ -f /usr/local/openvpn_as/scripts/twistd.pid ]; then
    rm -f /usr/local/openvpn_as/scripts/twistd.pid
fi

if [ ! -f /dev/net/tun ]; then
 mkdir -p /dev/net
 mknod /dev/net/tun c 10 200
fi

/root/post_reqs.sh &

/usr/local/openvpn_as/scripts/openvpnas -n --logfile=/var/log/openvpn.log


