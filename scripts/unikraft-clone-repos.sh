#!/bin/bash

if [ "$#" -ne 1 ]; then
	echo "Usage: $0 <directory>"
	exit -2
fi

DIR="$1"
XEN_REPO_ROOT="git://xenbits.xen.org/unikraft"
GITHUB_REPO_ROOT="https://github.com/nets-cs-pub-ro"
USE_GITHUB=1

LIBS=(\
	newlib
        lwip
)
APPS=(\
	helloworld
)

entry_dir() { pushd $1 &>/dev/null; }
exit_dir()  { popd &>/dev/null;     }

get_repo_root() {
	[ $USE_GITHUB -eq 1 ] \
		&& echo $GITHUB_REPO_ROOT \
		|| echo $XEN_REPO_ROOT
}

get_repo_lib() {
	local libname="$1"
	[ $USE_GITHUB -eq 1 ] \
		&& echo "$GITHUB_REPO_ROOT/unikraft-lib-$libname.git" \
		|| echo "$XEN_REPO_ROOT/libs/$libname.git"
}

mkdir -p $DIR
entry_dir $DIR

# Clone kernel
[ ! -d  "$DIR/unikraft" ] && git clone "$(get_repo_root)/unikraft.git"

# Clone libs
mkdir -p "libs"
entry_dir "libs"
for l in ${LIBS[@]}; do
	[ ! -d  "$DIR/libs/$l" ] && git clone "$(get_repo_lib $l)" $l
done
exit_dir

# Clone apps
mkdir -p "apps"
entry_dir "apps"
for a in ${APPS[@]}; do
	[ ! -d  "$DIR/apps/$a" ] && git clone "$XEN_REPO_ROOT/apps/$a.git"
done
exit_dir

exit_dir
