#!/bin/sh

git pull origin main
bundle install
ruby main.rb
