#!/bin/sh
# P2 VTEP2 multicast VXLAN: VNI 10, group 239.1.1.1
# Run on FRR/router node connected to host_chchao-2 via eth1

ip link add br0 type bridge
ip link set dev br0 up

ip link set dev eth0 up
ip addr add 10.1.1.2/24 dev eth0

ip link add name vxlan10 type vxlan id 10 dev eth0 group 239.1.1.1 dstport 4789
ip addr add 20.1.1.2/24 dev vxlan10
ip link set dev vxlan10 up

ip link set dev eth1 up
ip link set dev eth1 master br0
ip link set dev vxlan10 master br0
