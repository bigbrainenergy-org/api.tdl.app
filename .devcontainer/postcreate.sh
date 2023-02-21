#!/bin/bash

echo "POSTCREATE: proceeding with build steps"
bundle --version

echo "POSTCREATE: bundle config set path /workspaces/$1/vendor/cache"
bundle config set path /workspaces/$1/vendor/cache

echo "POSTCREATE: bundle install"
bundle install --jobs=1

# RESET
echo "POSTCREATE: rails db:reset"
rails db:reset

#######################################################
# RESET IS EQUIVALENT TO THIS SECTION
# db:reset = db:drop && db:setup
# echo "POSTCREATE: rails db:drop"
# rails db:drop

# echo "POSTCREATE: rails db:setup"
# comment out until we know the db is getting connected
# rails db:setup
#######################################################

echo "POSTCREATE: rails s"
rails s

echo "FINISHED"