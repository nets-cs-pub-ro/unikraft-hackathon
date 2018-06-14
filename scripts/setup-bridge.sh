#!/bin/bash

bridge_create() {
	brctl addbr $BRIDGE
	brctl setageing $BRIDGE $((60 * 60 * 24))
	ip link set $BRIDGE up
}

bridge_add() {
	brctl addif $BRIDGE $PIPE_END_GUEST
}

bridge_delete() {
	ip link delete $PIPE_END_HOST
	ip link delete $BRIDGE
}

pipe_create() {
	ip link add $PIPE_END_HOST type veth peer name $PIPE_END_GUEST
}

pipe_up() {
	ip link set $PIPE_END_GUEST up
	ip link set $PIPE_END_HOST up
	ip address add $GATEWAY_IP dev $PIPE_END_HOST
}

pipe_setup() {
	pipe_create
	pipe_up
}

do_start() {
	bridge_create
	pipe_setup
	bridge_add
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
