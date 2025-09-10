#!/bin/bash

echo "Switching to API directory"

cd tunehaven-api

echo "Pulling Git changes"

git checkout main && git pull

echo "Restarting Docker services"

docker compose -f docker-compose.prod.yml up -d
