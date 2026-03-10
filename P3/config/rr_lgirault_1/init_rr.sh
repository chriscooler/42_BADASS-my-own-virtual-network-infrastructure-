#!/bin/sh
set -e

# Monter les interfaces
ip link set lo up
ip link set eth0 up
ip link set eth1 up
ip link set eth2 up

# Démarrer FRR (lira /etc/frr/frr.conf)
/usr/lib/frr/frrinit.sh start

exec /bin/sh
