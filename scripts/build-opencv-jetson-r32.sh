#!/usr/bin/env bash

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

mkdir -p ${SCRIPT_DIR}/../build/opencv-jetson-r32
cd ${SCRIPT_DIR}/../docker

docker build -t opencv-jetson-r32 -f Dockerfile.opencv-jetson-r32 .
docker run --rm -it -v ${SCRIPT_DIR}/../build/opencv-jetson-r32:/build opencv-jetson-r32
