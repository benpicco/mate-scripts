#!/bin/bash

upstream_git=$1
fork_git=$2
since=$3
branch=$4

migrate=`dirname $0`/migrate.sh

if [ -z $since ]; then
	echo "usage: $0 [upstream_git] [forked_git] [since] [branch]"
	exit 1
fi

if [ -z $branch ]; then
	branch="master"
fi

echo "Checking out $upstream_git (upstream)…"

mkdir patches
git clone --branch $branch $upstream_git upstream
cd upstream
git format-patch -o ../patches $since
cd ../patches
$migrate
cd ..

echo "Checking out $fork_git (fork)…"
git clone $fork_git fork
cd fork
for patch in ../patches/*.patch; do
	if git apply --check $patch 2> /dev/null; then
		git am < $patch
		rm $patch
	else
		echo "$patch failed!"
	fi
done
