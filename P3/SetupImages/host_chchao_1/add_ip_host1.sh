#!/bin/sh
# P3 host_chchao_1: simple L2/L3 host behind router_chchao_1
# By default: bring eth1 up, no IP (for EVPN MAC-only tests)
# If you want an IP for ping, uncomment the ip addr line.

set -e

ip link set eth1 up

# Uncomment for ping tests:
# ip addr add 20.1.1.10/24 dev eth1

exec /bin/sh

