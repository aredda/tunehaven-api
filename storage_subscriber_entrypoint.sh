#!/bin/bash

echo "Bundle Check"

bundle check || bundle install

echo "Starting Storage Listener"

ruby bin/storage_subscriber
