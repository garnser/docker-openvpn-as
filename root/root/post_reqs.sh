#!/usr/bin/env bash

sleep 15

SACLI=/usr/local/openvpn_as/scripts/sacli

# Set up admin account
if [ -n ${OPENVPN_ADMIN_USER} ]; then
    userstatus=$(${SACLI} --pfilt $OPENVPN_ADMIN_USER UserPropGet | jq --arg openvpn_admin_user "$OPENVPN_ADMIN_USER" '.[$openvpn_admin_user]')

    if [[ $userstatus == "null" ]]; then
	${SACLI} --user ${OPENVPN_ADMIN_USER} --key "type" --value "user_connect" UserPropPut
	${SACLI} --user ${OPENVPN_ADMIN_USER} --key "prop_superuser" --value "true" UserPropPut
    fi

    if [ -n ${OPENVPN_ADMIN_PASS} ]; then
	${SACLI} --user ${OPENVPN_ADMIN_USER} --new_pass ${OPENVPN_ADMIN_PASS} SetLocalPassword
    fi
fi


# Provision certificates
if [[ $(mount | grep -q '/usr/local/openvpn_as/etc/web-ssl') ]]; then
    ${SACLI} --import GetActiveWebCerts
fi

if [ -f /root/config.json ]; then
    keys=$(jq -rc '. | keys[] as $k | $k' /root/config.json)
    for key in $keys; do
	value=$(jq -rc --arg key "$key" '.[$key]' /root/config.json)
	${SACLI} --key "${key}" --value "${value}" ConfigPut
    done
fi
${SACLI} start

