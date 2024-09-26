#!/usr/bin/env bash

set -e

PLATFORMS=("jetson-r32" "x64")
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PLATFORM=$1

# Validate arguments
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <platform (${PLATFORMS[@]})>"
  exit 1
fi
if [[ ! " ${PLATFORMS[@]} " =~ " ${PLATFORM} " ]]; then
  echo "Invalid platform: ${PLATFORM}"
  echo "Valid platforms: ${PLATFORMS[@]}"
  exit 1
fi

cd ${SCRIPT_DIR}/../docker

if [ "${PLATFORM}" == "x64" ]; then
  DOCKER_PLATFORM="linux/amd64"
else
  DOCKER_PLATFORM="linux/arm64"
fi

docker build --platform ${DOCKER_PLATFORM} -t ci-install-test-${PLATFORM} -f Dockerfile.ci-install-test-${PLATFORM} .
