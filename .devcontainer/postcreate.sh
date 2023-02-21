#!/bin/bash

echo "POSTCREATE: bundle install"
bundle install

echo "POSTCREATE: rails db:reset"
rails db:reset

echo "POSTCREATE: rails s"
rails s