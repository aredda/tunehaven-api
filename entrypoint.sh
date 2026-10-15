#!/bin/bash
set -euo pipefail

echo "Bundle Check"

bundle check || bundle install

echo "Preparing Database"

bundle exec rails db:prepare

echo "Starting Server"

exec bundle exec rails s -b 0.0.0.0
