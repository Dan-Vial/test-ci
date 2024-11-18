#!/bin/bash
set -e

echo "Starting create release with TAG..." >> log-ci.log
gh release create "$2" "./$1-$2-dist.tar.gz" --target "$3" >> log-ci.log
