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

# Provision config
if [ -f /root/config.json ]; then
    keys=$(jq -rc '. | keys[] as $k | $k' /root/config.json)
    for key in $keys; do
	value=$(jq -rc --arg key "$key" '.[$key]' /root/config.json)
	${SACLI} --key "${key}" --value "${value}" ConfigPut
    done
fi

# Provision groups
if [ -f /root/groups.json ]; then
    groups=$(jq -rc '. | . as $groups| keys_unsorted | map(select($groups[.].type=="group")) | .[]' /root/groups.json)
    
    for group in $groups; do
	${SACLI} --user $group --key "type" --value "group" UserPropPut
	${SACLI} --user $group --key "group_declare" --value "true" UserPropPut
	while IFS=, read -r key value;  do
	    ${SACLI} --user $group --key "$key" --value "$value" UserPropPut
	done < <(jq -rc --arg group "$group" '.[$group] | to_entries[] | [.key, .value] | @csv' /root/groups.json | tr -d '"' | grep -v 'type,group')
    done
fi

    
${SACLI} start

