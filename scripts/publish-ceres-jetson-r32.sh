#!/usr/bin/env bash

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

S3_BUCKET=repo.download.mvi.llc
CERES_VERSION=2.2.0
DEB_FILENAME="libceres-dev_${CERES_VERSION}_arm64.deb"
BUILD_DIR="${SCRIPT_DIR}/../build/ceres-jetson-r32"
META_DIR="${SCRIPT_DIR}/../meta"

if [ ! -f ${BUILD_DIR}/${DEB_FILENAME} ]; then
  echo "${BUILD_DIR}/${DEB_FILENAME} not found. Run ./scripts/build-ceres-jetson-r32.sh first."
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

# Upload the ceres deb package to S3
docker run --rm \
  -v ~/.aws:/root/.aws \
  -v ${BUILD_DIR}:/build \
  -e GPG_PRIVATE_KEY="${GPG_PRIVATE_KEY}" \
  deb-s3 upload --bucket "${S3_BUCKET}" --arch arm64 --prefix jetson/common --codename=r32.7 --sign ${GPG_PUBLIC_KEY} /build/${DEB_FILENAME}
