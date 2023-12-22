#!/usr/bin/env bash
# vim: filetype=sh
#
# Install my dev environment including vim, dotfiles, go, node, and ui stuff
#
#

SETUP_PATH="$(dirname $0)"
echo "Building dockerfile in $SETUP_PATH"
echo "=================================="
docker rm --force dotfiles
docker build . --progress=plain -f "$SETUP_PATH/Dockerfile" -t nkcraddock/dotfiles
docker run -i --rm --name dotfiles nkcraddock/dotfiles /bin/bash setup/test.sh




