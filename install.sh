#!/bin/bash

# Install all my things
apt-get update && apt-get install -y \
  git \
  vim \
  curl \
  ruby1.9.3 \
  wget \
  mercurial \
  build-essential \
  silversearcher-ag

# Grab my homesick castle
gem install homesick
yes no | homesick clone nkcraddock/dotfiles

