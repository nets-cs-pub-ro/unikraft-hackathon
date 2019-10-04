#!/bin/bash

bridge_create() {
	brctl addbr $BRIDGE
	brctl setageing $BRIDGE $((60 * 60 * 24))
	ip link set $BRIDGE up
}

bridge_delete() {
	ip link delete $BRIDGE
}

do_start() {
	bridge_create
}

do_stop() {
	bridge_delete
}


if [ "$#" -ne 1 ]; then
	echo "Usage: $0 (start|stop)"
	exit -2
fi

SCRIPT_DIR="$(dirname $0)"
source "$SCRIPT_DIR/config.sh"


case $1 in
"start")
	do_start
	;;
"stop")
	do_stop
	;;
"pipe-up")
	pipe_up
	;;
*)
	echo "Invalid param"
	exit 2
	;;
esac
