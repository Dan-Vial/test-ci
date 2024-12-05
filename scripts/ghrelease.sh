#!/bin/bash
set -e

echo "Starting create release with TAG..." >> log-ci.log
gh release create "$2" "./${1}-${2}-dist.tar.gz" --target "$3" >> log-ci.log

# Envoyer un événement webhook personnalisé
curl -X POST \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"event_type":"release_created","client_payload":{"tag":"'"$2"'"}}' \
  "https://api.github.com/repos/${4}/dispatches" >> log-ci.log