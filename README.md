# docker-openvpn-as
Docker image for OpenVPN-AS

# Configuration
## Admin user
To create an admin-user define the following environment variables:

```
OPENVPN_ADMIN_USER=openvpn
OPENVPN_ADMIN_PASS=suersecretpassword
```

## Overall configuration
Copy `config.json.example` to `config.json` and make the appropiate changes to best suit your environment. This file will be loaded upon container start and update the configuration.

# Credits
Based on https://github.com/linuxserver-archive/docker-openvpn-as which has been deprecated.
