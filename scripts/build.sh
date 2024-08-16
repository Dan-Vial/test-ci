#!/bin/bash
set -e

cd $1
echo "Starting $1 build..."
npm ci
npm test
npm run build
cd ..