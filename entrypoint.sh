#!/bin/bash

echo "Bundle Check"

bundle check || bundle install

echo "Migrating DB Changes"

RAILS_ENV=production bundle exec rails db:migrate

echo "Starting Server"

bundle exec rails s -b 0.0.0.0 -e production
