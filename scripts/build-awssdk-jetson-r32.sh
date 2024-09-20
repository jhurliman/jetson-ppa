#!/usr/bin/env bash

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

PACKAGE=awssdk

mkdir -p ${SCRIPT_DIR}/../build/${PACKAGE}-jetson-r32
cd ${SCRIPT_DIR}/../docker

docker build -t ${PACKAGE}-jetson-r32 -f Dockerfile.${PACKAGE}-jetson-r32 .
docker run --rm -v ${SCRIPT_DIR}/../build/${PACKAGE}-jetson-r32:/build ${PACKAGE}-jetson-r32
