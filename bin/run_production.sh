#!/bin/bash

rm /usr/src/app/tmp/pids/server.pid
bundle exec rails db:create db:migrate
bundle exec rails server -e RAILS_ENV=production
