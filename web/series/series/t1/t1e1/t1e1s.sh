#!/bin/bash

set -e -u
trap "echo \"$(tput bold)$(basename "$0") failed$(tput sgr 0)\" >&2" EXIT

WEB=~/me/web
WEBTMP=/tmp/series/t1e1s/web
WEBPAGES=t1e1s

# typically set to a tag once frozen to a specific state
GITBRANCH_OR_TAG=main

cd "${0%/*}"

if [ -d $WEBTMP ]; then rm -rf $WEBTMP; fi
git clone $WEB $WEBTMP
(cd $WEBTMP && git checkout $GITBRANCH_OR_TAG && source/web.sh pocket)
if [ -d $WEBPAGES ]; then rm -rf $WEBPAGES; fi
cp -rf $WEBTMP/workpocket $WEBPAGES
rm -rf $WEBTMP

trap - EXIT
