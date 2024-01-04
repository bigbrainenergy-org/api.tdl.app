#!/bin/bash

bundle exec rails db:create db:migrate
bundle exec rails server -e RAILS_ENV=production
