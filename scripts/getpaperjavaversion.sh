#!/usr/bin/env bash

set -e

if [ -z "$1" ]; then
  echo "Please provide paper version!"
  echo "./scripts/getpaperjavaversion.sh 1.17.1"
  exit 1
fi

version=$1

build=$(curl -s https://papermc.io/api/v2/projects/paper/versions/"${version}" | jq ".builds | last")

commit=$(curl -s https://papermc.io/api/v2/projects/paper/versions/"${version}"/builds/"${build}" | jq -r ".changes[0].commit")

if [ "$commit" == "null" ]; then
  echo "No commit found for version ${version}"
  exit 1
fi

[[ -z "$QUIET" ]] && echo "Latest commit of $version is $commit"

git --version 2>&1 >/dev/null
GIT_IS_AVAILABLE=$?

if [ $GIT_IS_AVAILABLE -ne 0 ]; then
  echo "Git is not available. We're not checking the code."
  exit 0
fi

# check if we already cloned the repo
if [ ! -d "work/Paper" ]; then
  mkdir work
  git clone https://github.com/PaperMC/Paper.git work/Paper
else
  git --git-dir=work/Paper/.git --work-tree=work/Paper fetch 2>&1 >/dev/null
  git --git-dir=work/Paper/.git --work-tree=work/Paper reset --hard origin/master 2>&1 >/dev/null
fi

# checkout the repo at commit in the work/Paper repo
git --git-dir=work/Paper/.git --work-tree=work/Paper checkout -f $commit 2>&1 >/dev/null

cd work/Paper

if [ -f paper ]; then
  [[ -z "$QUIET" ]] && echo "Applying patches using paper script"
  ./paper p 2>&1 >/dev/null
  [[ -z "$QUIET" ]] && echo "Successfully applied patches"
elif [ -f build.gradle.kts ]; then
  [[ -z "$QUIET" ]] && echo "Applying patches using gradle"
  ./gradlew applyPatches 2>&1 >/dev/null
  [[ -z "$QUIET" ]] && echo "Successfully applied patches"
else
  echo "Unable to apply patches"
  exit 1
fi

leastVersion=$(cat Paper-Server/src/main/java/org/bukkit/craftbukkit/Main.java | grep -oP 'at least Java (\d+)' | awk '{print $4}')
upToVersion=$(cat Paper-Server/src/main/java/org/bukkit/craftbukkit/Main.java | grep -oP 'up to Java (\d+)' | awk '{print $4}')
echo "At least Java ${leastVersion:=8}"
echo "Up to Java $upToVersion"
