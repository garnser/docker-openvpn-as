FROM rockylinux:8

RUN \
 dnf install -y \
     jq \
     iptables \
     python3-idna \
     python3-dateutil \
     python3-requests \
     https://as-repository.openvpn.net/as-repo-rhel8.rpm

RUN \
 dnf install -y \
 openvpn-as

COPY /root /
COPY as.conf /usr/local/openvpn_as/etc/
EXPOSE 943/tcp 1194/udp

CMD [ "/root/start_openvpn.sh" ]
