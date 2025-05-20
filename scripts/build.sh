#!/usr/bin/env bash

set -e

PLATFORMS=("jetson-r32" "x64")
PACKAGES=("awssdk" "ceres" "eigen" "ffmpeg" "opencv" "valgrind")
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PLATFORM=$1
PACKAGE=$2

# Validate arguments
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <platform (${PLATFORMS[@]})> <package (${PACKAGES[@]})>"
  exit 1
fi
if [[ ! " ${PLATFORMS[@]} " =~ " ${PLATFORM} " ]]; then
  echo "Invalid platform: ${PLATFORM}"
  echo "Valid platforms: ${PLATFORMS[@]}"
  exit 1
fi
if [[ ! " ${PACKAGES[@]} " =~ " ${PACKAGE} " ]]; then
  echo "Invalid package: ${PACKAGE}"
  echo "Valid packages: ${PACKAGES[@]}"
  exit 1
fi

# Create the package build directory
mkdir -p ${SCRIPT_DIR}/../build/${PACKAGE}-${PLATFORM}
cd ${SCRIPT_DIR}/../docker
if [ "${PLATFORM}" == "x64" ]; then
  DOCKER_PLATFORM="linux/amd64"
else
  DOCKER_PLATFORM="linux/arm64"
fi

# Only run Docker in interactive mode if a TTY is present
if [ -t 1 ]; then
  DOCKER_ARGS="-it"
else
  DOCKER_ARGS=""
fi

# Build the Docker image where the package will be built
docker build --platform ${DOCKER_PLATFORM} -t ${PACKAGE}-${PLATFORM} -f Dockerfile.${PACKAGE}-${PLATFORM} .
# Run the Docker container to build the package and create a .deb
docker run --platform ${DOCKER_PLATFORM} --rm ${DOCKER_ARGS} -v ${SCRIPT_DIR}/../build/${PACKAGE}-${PLATFORM}:/build ${PACKAGE}-${PLATFORM}
