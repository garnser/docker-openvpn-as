FROM rockylinux:8

RUN \
 dnf install -y \
     iptables \
     python3-idna \
     python3-dateutil \
     iproute \
     https://as-repository.openvpn.net/as-repo-rhel8.rpm

RUN \
 dnf install -y \
 openvpn-as

COPY /root /
EXPOSE 943/tcp 1194/udp

CMD [ "/root/start_openvpn.sh" ]
