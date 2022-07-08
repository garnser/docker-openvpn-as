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
if [ -n ${AUTH_SAML_0_IDP_ENTITYID} ]; then
    ${SACLI} --key "auth.saml.0.idp_entityid" --value "${AUTH_SAML_0_IDP_ENTITYID}" ConfigPut
fi
if [ -n ${AUTH_SAML_0_SP_HOSTNAME} ]; then
    ${SACLI} --key "auth.saml.0.sp_hostname" --value "${AUTH_SAML_0_SP_HOSTNAME}" ConfigPut
fi
if [ -n ${AUTH_SAML_0_IDP_LOGOUT_ENDPOINT} ]; then
    ${SACLI} --key "auth.saml.0.idp_logout_endpoint" --value "${AUTH_SAML_0_IDP_LOGOUT_ENDPOINT}" ConfigPut
fi
if [ -n ${AUTH_SAML_0_IDP_CERT} ]; then
    ${SACLI} --key "auth.saml.0.idp_cert" --value "${AUTH_SAML_0_IDP_CERT}" ConfigPut
fi
if [ -n ${AUTH_SAML_0_ENABLE} ]; then
    ${SACLI} --key "auth.saml.0.enable" --value "${AUTH_SAML_0_ENABLE}" ConfigPut
fi
if [ -n ${AUTH_SAML_0_IDP_SIGNON_ENDPOINT} ]; then
    ${SACLI} --key "auth.saml.0.idp_signon_endpoint" --value "${AUTH_SAML_0_IDP_SIGNON_ENDPOINT}" ConfigPut
fi
if [ -n ${AUTH_SAML_0_TIMEOUT} ]; then
    ${SACLI} --key "auth.saml.0.timeout" --value "${AUTH_SAML_0_TIMEOUT}" ConfigPut
fi
${SACLI} start

