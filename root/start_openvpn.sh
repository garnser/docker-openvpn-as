#!/usr/bin/env bash

PIDFILE=/usr/local/openvpn_as/openvpnas.pid

# Remove old PID
if [ -f ${PIDFILE} ]; then
    rm -f ${PIDFILE}
fi

if [ ! -f /dev/net/tun ]; then
 mkdir -p /dev/net
 mknod /dev/net/tun c 10 200
fi

/root/post_reqs.sh &

/usr/local/openvpn_as/scripts/openvpnas -n --logfile=/var/log/openvpn.log --pidfile=${PIDFILE}


