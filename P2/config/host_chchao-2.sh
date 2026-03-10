#!/bin/sh
# P2 host_chchao-2: L2 host behind VTEP2, IP for ping test
ip link set dev eth0 up
ip addr add 20.1.1.20/24 dev eth0
