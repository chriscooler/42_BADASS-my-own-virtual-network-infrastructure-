#!/bin/sh
ip link set eth0 up
# For ping: ip addr add 20.1.1.30/24 dev eth0
exec /bin/sh
