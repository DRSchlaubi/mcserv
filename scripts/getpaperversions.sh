#!/usr/bin/env bash

for version in "$@"
do
  echo "Checking $version"
  QUIET=true ./scripts/getpaperjavaversion.sh $version
done
