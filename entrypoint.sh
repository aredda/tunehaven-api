#!/bin/bash
set -euo pipefail

echo "Bundle Check"

bundle check || bundle install

echo "Migrating DB Changes"

bundle exec rails db:migrate

echo "Starting Server"

exec bundle exec rails s -b 0.0.0.0
