#!/usr/bin/env bash

sleep 10

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


if [ -n ${VPN_SERVER_ROUTING_PRIVATE_ACCESS} ]; then
    ${SACLI} --key "vpn.server.routing.private_access" --value "${VPN_SERVER_ROUTING_PRIVATE_ACCESS}" ConfigPut
fi
if [ -n ${VPN_CLIENT_ROUTING_REROUTE_GW} ]; then
    ${SACLI} --key "vpn.client.routing.reroute_gw" --value "${VPN_CLIENT_ROUTING_REROUTE_GW}" ConfigPut
fi
if [ -n ${VPN_SERVER_DHCP_OPTION_DOMAIN} ]; then
    ${SACLI} --key "vpn.server.dhcp_option.domain" --value "${VPN_SERVER_DHCP_OPTION_DOMAIN}" ConfigPut
fi
if [ -n ${HOST_NAME} ]; then
    ${SACLI} --key "host.name" --value "${HOST_NAME}" ConfigPut
fi
#if [ -n ${} ]; then
#    ${SACLI} --key "" --value "${}" ConfigPut
#fi
${SACLI} start

