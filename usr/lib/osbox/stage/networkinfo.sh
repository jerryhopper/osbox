#!/bin/bash

source /usr/lib/osbox/func/networktools.sh


PRIM=$(ip addr show eth0|grep "scope global"|awk  '{print $2}')
SEC=$(ip addr show eth0|grep "scope global secondary"|awk  '{print $2}')



find_IPv4_information


echo "$PRIM,$SEC|$IPv4gw"
