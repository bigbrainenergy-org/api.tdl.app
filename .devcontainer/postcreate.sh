#!/bin/bash

bundle config set path vendor/bundle
bundle install --jobs=1
bundle exec rails db:reset
rm -f ./tmp/pids/server.pid
bundle exec rails s
