#!/bin/bash

if [ "$#" -ne 1 ]; then
	echo "Usage: $0 <ifname>"
	exit -2
fi

SCRIPT_DIR="$(dirname $0)"
source "$SCRIPT_DIR/config.sh"


brctl addif $BRIDGE $1 
ip link set $1 up
