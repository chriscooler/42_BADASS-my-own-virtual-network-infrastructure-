FROM frrouting/frr:latest

RUN apt-get update && apt-get install -y --no-install-recommends \
    iproute2 iputils-ping tcpdump busybox \
    && rm -rf /var/lib/apt/lists/* \
    && sed -i 's/bgpd=no/bgpd=yes/' /etc/frr/daemons \
    && sed -i 's/ospfd=no/ospfd=yes/' /etc/frr/daemons \
    && sed -i 's/isisd=no/isisd=yes/' /etc/frr/daemons

COPY init_router_lgirault_2.sh /usr/local/bin/init_router_lgirault_2.sh
RUN chmod +x /usr/local/bin/init_router_lgirault_2.sh

COPY frr.conf /etc/frr/frr.conf
RUN chown frr:frr /etc/frr/frr.conf && chmod 640 /etc/frr/frr.conf

ENTRYPOINT ["/usr/local/bin/init_router_lgirault_2.sh"]
