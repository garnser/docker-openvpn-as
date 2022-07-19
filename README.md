# docker-openvpn-as
Docker image for OpenVPN-AS

# Configuration
## Admin user
To create an admin-user define the following environment variables:

```
OPENVPN_ADMIN_USER=openvpn
OPENVPN_ADMIN_PASS=suersecretpassword
```

## Base configuration
Copy `config.json.example` to `config.json` and make the appropiate changes to best suit your environment. This file will be loaded upon container start and update the configuration.

Note that this method can become quite slow and is better suited for initial deployment or IaC controlled environments. To make things a bit quicker consider using Persistent configuration below instead.

Make sure to add this to volumes definitions.

## Group provisioning
Copy `groups.json.example` to `groups.json` and make the appropiate changes to best suit your environment. This file will be loaded upon container start and update the configuration.

Make sure to add this to volumes definitions.

# Persistent configuration
Given the way the image is built certificates may/will roll over. This will be fixed in future releases, this may however in it's current state cause user profiles to become invalid as the certificates doesn't match up. To avoid this behaviour do as follows after the first start.

`docker cp openvpn-as:/usr/local/openvpn_as/etc/db .`

Add the following to the volumes definition:
`      - ./db:/usr/local/openvpn_as/etc/db`



# Credits
Based on https://github.com/linuxserver-archive/docker-openvpn-as which has been deprecated.
