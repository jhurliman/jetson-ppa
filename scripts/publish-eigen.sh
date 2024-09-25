#!/usr/bin/env bash

set -e

PLATFORMS=("jetson-r32" "x64")
S3_BUCKET=repo.download.mvi.llc
VERSION=3.4.0
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

# Ensure the .deb exists
if [ "${PLATFORM}" == "x64" ]; then
  DEB_FILENAME="libeigen3-dev_${VERSION}_amd64.deb"
else
  DEB_FILENAME="libeigen3-dev_${VERSION}_arm64.deb"
fi
BUILD_DIR="${SCRIPT_DIR}/../build/eigen-${PLATFORM}"
if [ ! -f ${BUILD_DIR}/${DEB_FILENAME} ]; then
  echo "${BUILD_DIR}/${DEB_FILENAME} not found. Run ./scripts/build.sh ${PLATFORM} eigen first."
  exit 1
fi

# Ensure GPG_PUBLIC_KEY and GPG_PRIVATE_KEY are set
if [ -z "${GPG_PUBLIC_KEY}" ] || [ -z "${GPG_PRIVATE_KEY}" ]; then
  echo "GPG_PUBLIC_KEY and GPG_PRIVATE_KEY must be set."
  exit 1
fi

cd ${SCRIPT_DIR}/../docker

# Build deb-s3 CLI utility tool image
docker build -t deb-s3 -f Dockerfile.deb-s3 .

if [ "${PLATFORM}" == "jetson-r32" ]; then
  DEB_S3_CMD="deb-s3 upload --bucket "${S3_BUCKET}" --arch arm64 --prefix jetson/common --codename=r32.7 --sign ${GPG_PUBLIC_KEY} /build/${DEB_FILENAME}"
elif [ "${PLATFORM}" == "x64" ]; then
  DEB_S3_CMD="deb-s3 upload --bucket "${S3_BUCKET}" --arch amd64 --prefix ubuntu/x64 --codename=jammy --sign ${GPG_PUBLIC_KEY} /build/${DEB_FILENAME}"
fi

# Upload the libeigen3-dev deb package to S3
docker run --rm \
  -v ~/.aws:/root/.aws \
  -v ${BUILD_DIR}:/build \
  -e GPG_PRIVATE_KEY="${GPG_PRIVATE_KEY}" \
  ${DEB_S3_CMD}
