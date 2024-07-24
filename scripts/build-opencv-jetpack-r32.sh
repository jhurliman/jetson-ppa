#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

mkdir -p ${SCRIPT_DIR}/../build
cd ${SCRIPT_DIR}/../docker

docker build -t opencv-jetpack-r32 -f Dockerfile.opencv-jetpack-r32 .
