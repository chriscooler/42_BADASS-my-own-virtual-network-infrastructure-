#!/bin/sh
# P2 VTEP1 static VXLAN: VNI 10, remote 10.1.1.2 (VTEP2)
# Run on FRR/router node connected to host_chchao-1 via eth1

# bridge for local host + vxlan
ip link add br0 type bridge
ip link set dev br0 up

# underlay interface
ip link set dev eth0 up
ip addr add 10.1.1.1/24 dev eth0

# static VXLAN (no multicast group)
ip link add name vxlan10 type vxlan id 10 dev eth0 dstport 4789 remote 10.1.1.2
ip addr add 20.1.1.1/24 dev vxlan10
ip link set dev vxlan10 up

# attach host + vxlan to bridge
ip link set dev eth1 up      # towards host_chchao-1
ip link set dev eth1 master br0
ip link set dev vxlan10 master br0

