#!/bin/bash

usage_and_exit() {
	echo "Usage: $0 <kernel-path> [<ifname> <mac>]"
	exit -2
}

check_if() {
	local ifname="$1"

	ip l show $ifname &>/dev/null
	if [ -n $? ]; then
		# create new tap interface
		sudo tunctl -u $(whoami) -t $IFNAME

		# enable the interface
		sudo $SCRIPT_DIR/ifup.sh $IFNAME
	fi

}

# Check params
[ "$#" -eq 0 ] && usage_and_exit

KERNEL="$1"
IFNAME="$2"
MAC="$3"

SCRIPT_DIR="$(dirname $0)"

# setup network interface
if [ -n "$IFNAME" ]; then
	[ -z "$MAC" ] && usage_and_exit

	shift 3
	check_if $IFNAME

	QEMU_NET_PARAMS="-net nic,macaddr=$MAC,model=virtio -net tap,ifname=$IFNAME,script=no,downscript=no"
else
	shift 1
fi

# run Qemu
qemu-system-x86_64 -enable-kvm -nographic -device isa-debug-exit \
	-kernel $KERNEL \
	$QEMU_NET_PARAMS \
	"$@"

