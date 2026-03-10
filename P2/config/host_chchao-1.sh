#!/bin/sh
# P2 host_chchao-1: L2 host behind VTEP1, IP for ping test
ip link set dev eth0 up
ip addr add 20.1.1.10/24 dev eth0
