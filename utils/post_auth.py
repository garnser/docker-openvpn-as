#!/usr/bin/python3

# POST-auth script to match KeyCloak roles towards OpenVPN groups

import requests
import json

from pyovpn.plugin import *

def post_auth(authcred, attributes, authret, info):

    if info.get('auth_method') == 'local':
        return authret

    group = ""
    proplist_save = {}

    baseurl = 'https://fqdn'
    realm = 'master'
    authorized = False

    auth_headers = {'Content-Type': 'application/x-www-form-urlencoded'}
    auth_data = {'username': "username",
                 'password': 'password',
                 'grant_type': 'password',
                 'client_id': 'admin-cli'}

    auth_response = requests.post(baseurl + '/realms/' + realm + '/protocol/openid-connect/token',
                                  headers=auth_headers,
                                  data=auth_data)

    access_token = auth_response.json()["access_token"]

    x_headers = {'Accept': 'application/json',
                 'Authorization': 'Bearer ' + access_token}

    user_response = requests.get(baseurl + '/admin/realms/' + realm + '/users?username=' + authcred["username"] + '&exact=true',
                    headers=x_headers)

    user_id = user_response.json()[0]["id"]

    group_response = requests.get(baseurl + '/admin/realms/' + realm + '/users/' + user_id + '/groups',
                                 headers=x_headers)

    for group in group_response.json():
        if group["name"] == "openvpn_users":
            authorized = True

    if not authorized:
        authret['status'] = FAIL
        authret['reason'] = "unauthorized user"
        authret['client_reason'] = "Unauthorized"

    role_response = requests.get(baseurl + '/admin/realms/' + realm + '/users/' + user_id + '/role-mappings/realm',
                                 headers=x_headers)

    for role in role_response.json():
        if role["name"] == "role1":
            group = role["name"]

    proplist_save['conn_group'] = group

    return authret, proplist_save
