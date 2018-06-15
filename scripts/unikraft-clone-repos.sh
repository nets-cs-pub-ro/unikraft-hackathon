#!/bin/bash

if [ "$#" -ne 1 ]; then
	echo "Usage: $0 <directory>"
	exit -2
fi

DIR="$1"
REPO="git://xenbits.xen.org/unikraft"
LIBS=(\
	newlib
        lwip
)
APPS=(\
	helloworld
)

entry_dir() { pushd $1 &>/dev/null; }
exit_dir()  { popd &>/dev/null;     }

mkdir -p $DIR
entry_dir $DIR

# Clone kernel
[ ! -d  "$DIR/unikraft" ] && git clone "$REPO/unikraft.git"

# Clone libs
mkdir -p "libs"
entry_dir "libs"
for l in ${LIBS[@]}; do
	[ ! -d  "$DIR/libs/$l" ] && git clone "$REPO/libs/$l.git"
done
exit_dir

# Clone apps
mkdir -p "apps"
entry_dir "apps"
for a in ${APPS[@]}; do
	[ ! -d  "$DIR/apps/$a" ] && git clone "$REPO/apps/$a.git"
done
exit_dir

exit_dir
