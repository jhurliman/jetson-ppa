#!/usr/bin/env bash

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

mkdir -p ${SCRIPT_DIR}/../build/eigen-jetson-r32
cd ${SCRIPT_DIR}/../docker

docker build -t eigen-jetson-r32 -f Dockerfile.eigen-jetson-r32 .
docker run --rm -v ${SCRIPT_DIR}/../build/eigen-jetson-r32:/build eigen-jetson-r32
