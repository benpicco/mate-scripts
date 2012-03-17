#!/bin/bash
#
# checks out a mate and a gnome repository,
# then extracts and converts all gnome patches
# from since mate has been forked and tries to apply them

upstream_git=$1
fork_git=$2
since=$3
branch=$4

migrate=`pwd`/`dirname $0`/migrate.sh

if [ -z $since ]; then
	echo "usage: $0 [upstream_git] [forked_git] [since] [branch]"
	exit 1
fi

if [ -z $branch ]; then
	branch="master"
fi

echo "Checking out $upstream_git (upstream)…"

mkdir patches
mkdir patches/skipped
git clone --branch $branch $upstream_git upstream
cd upstream
git format-patch -o ../patches $since
cd ../patches
$migrate
cd ..

echo "Checking out $fork_git (fork)…"
git clone $fork_git fork

# since mate was created from tarballs, .gitignore might be missing
if [ ! -f fork/.gitignore ] && [ -f upstream/.gitignore ]; then
	cd upstream
	git checkout $since .gitignore
	cp .gitignore ../fork/
	git checkout $branch .gitignore
	cd ../fork

	# also migrate .gitignore…
	oldpath=`pwd`
	mkdir /tmp/gitignore
	mv .gitignore /tmp/gitignore/
	cd /tmp/gitignore
	$migrate
	cd $oldpath
	mv /tmp/gitignore/.gitignore .
	rmdir /tmp/gitignore

	git add .gitignore
	git commit .gitignore -m "add .gitignore from gnome"
	cd ..
fi

cd fork
for patch in ../patches/*.patch; do
	if [[ `echo $patch | tr [:upper:] [:lower:]` == *translation*  ]]; then
		mv $patch ../patches/skipped/
		echo "skipping $patch"
	else
		if git apply --check $patch 2> /dev/null; then
			git am < $patch
			rm $patch
		else
			echo "$patch failed!"
		fi
	fi
done
