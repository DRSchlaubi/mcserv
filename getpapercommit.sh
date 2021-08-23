#!/usr/bin/env bash

if [ -z "$1" ]; then
  echo "Please provide paper version!"
  echo "./getpapercommit.sh 1.17.1"
  exit 1
fi

version=$1

build=$(curl -s https://papermc.io/api/v2/projects/paper/versions/"${version}" | jq ".builds | last")

commit=$(curl -s https://papermc.io/api/v2/projects/paper/versions/"${version}"/builds/"${build}" | jq ".changes[0].commit")

echo "Latest commit of $version is $commit"
