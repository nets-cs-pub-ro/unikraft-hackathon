#!/bin/bash

if [ "$#" -ne 1 ]; then
	echo "Usage: $0 <directory>"
	exit -2
fi

DIR="$1"
XEN_REPO_ROOT="git://xenbits.xen.org/unikraft"
GITHUB_REPO_ROOT="https://github.com/unikraft"
USE_GITHUB=1

BRANCH=staging

UNIKRAFT_BRANCH=$BRANCH
LIBS=(\
	"newlib $BRANCH"
        "lwip $BRANCH"
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
		&& echo "unikraft-lib-$libname" \
		|| echo "libs/$libname"
}

clone_and_checkout() {
	local reponame="$1"
	local branchname="$2"
	local foldername="$3"
	[ ! -d $foldername ] && \
		git clone "$(get_repo_root)/$reponame.git" && \
		mv $reponame $foldername

	entry_dir $foldername && \
		git checkout $branchname && \
		exit_dir
}

mkdir -p $DIR
entry_dir $DIR

# Clone kernel
clone_and_checkout "unikraft" $UNIKRAFT_BRANCH "unikraft"

# Clone libs
mkdir -p "libs"
entry_dir "libs"

for ((i = 0; i < ${#LIBS[@]}; i++)); do
	read libname libbranch < <(echo ${LIBS[$i]});
	clone_and_checkout "$(get_repo_lib $libname)" $libbranch $libname
done
exit_dir

# Clone apps
mkdir -p "apps"
entry_dir "apps"
for ((i = 0; i < ${#APPS[@]}; i++)); do
	a=${APPS[$i]}
	[ ! -d  "$DIR/apps/$a" ] && git clone "$XEN_REPO_ROOT/apps/$a.git"
done
exit_dir

exit_dir
