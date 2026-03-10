FROM frrouting/frr:latest

# busybox + basic tools
RUN apt-get update && apt-get install -y busybox iproute2 tcpdump && rm -rf /var/lib/apt/lists/*

COPY frr/daemons /etc/frr/daemons
COPY frr/frr.conf /etc/frr/frr.conf
COPY frr/bgpd.conf /etc/frr/bgpd.conf
COPY frr/ospfd.conf /etc/frr/ospfd.conf
COPY frr/isisd.conf /etc/frr/isisd.conf

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
