#!/bin/bash
set -e

echo "Starting create archive TAR..."
mv frontend/dist backend/dist/public
tar -czvf "./$1-dist.tar.gz" -C backend/dist .