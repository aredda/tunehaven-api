#!/bin/bash
set -euo pipefail

echo "Bundle Check"

bundle check || bundle install

echo "Starting Storage Listener"

exec bundle exec ruby bin/storage_subscriber
