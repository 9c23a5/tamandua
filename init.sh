#!/bin/bash

eval "$(~/.local/bin/mise activate bash)"

cd ~/tamandua || return
mise activate

git pull --ff-only origin main
bundle install
ruby main.rb
