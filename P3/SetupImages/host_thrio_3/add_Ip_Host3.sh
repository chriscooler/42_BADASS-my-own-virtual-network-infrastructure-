#!/bin/sh
# Configuration automatique de l'interface eth1
ip link set eth0 up


# exec un shell ou garde le conteneur en vie
exec /bin/sh
