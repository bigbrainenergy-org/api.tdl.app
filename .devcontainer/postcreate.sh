#!/bin/bash

echo "POSTCREATE: bundle config set path /workspaces/$1/vendor/cache"
bundle config set path /workspaces/$1/vendor/cache

echo "POSTCREATE: bundle install"
bundle install

echo "POSTCREATE: rails db:reset"
rails db:reset

echo "POSTCREATE: rails s"
rails s