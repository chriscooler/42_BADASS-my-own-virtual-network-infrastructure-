#!/bin/sh
ip link set eth0 up
# For ping: ip addr add 20.1.1.20/24 dev eth0
exec /bin/sh
