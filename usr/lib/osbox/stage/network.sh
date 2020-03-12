#!/bin/bash



if [ "$1" == "info" ]; then
    bash /usr/lib/osbox/stage/networkinfo.sh
    exit 0
fi
if [ "$1" == "scan" ]; then
    bash /usr/lib/osbox/stage/networkscan.sh
    exit 0
fi

if [ "$1" == "reset" ]; then
    #echo "network reset"
    bash /usr/lib/osbox/stage/networkreset.sh
    exit 0
fi
if [ "$1" == "set" ]; then
    #echo "network set"
    bash /usr/lib/osbox/stage/networksetstatic.sh $2 $3 $4
    exit 0
    sleep 1
fi

if [ "$1" == "current" ]; then
    #echo "network current"
    bash /usr/lib/osbox/stage/networkcurrent.sh
    exit 0
fi










