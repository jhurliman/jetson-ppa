#!/usr/bin/env bash

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

S3_BUCKET=repo.download.mvi.llc
OPENCV_VERSION=4.10.0
JETPACK_VERSION=4.6.5-ppa1
DEB_FILENAME="OpenCV-${OPENCV_VERSION}-arm64-dev.deb"
BUILD_DIR="${SCRIPT_DIR}/../build/opencv-jetson-r32"
META_DIR="${SCRIPT_DIR}/../meta"

if [ ! -f ${BUILD_DIR}/${DEB_FILENAME} ]; then
  echo "${BUILD_DIR}/${DEB_FILENAME} not found. Run ./scripts/build-opencv-jetson-r32.sh first."
  exit 1
fi

# Ensure GPG_PUBLIC_KEY and GPG_PRIVATE_KEY are set
if [ -z "${GPG_PUBLIC_KEY}" ] || [ -z "${GPG_PRIVATE_KEY}" ]; then
  echo "GPG_PUBLIC_KEY and GPG_PRIVATE_KEY must be set."
  exit 1
fi

cd ${SCRIPT_DIR}/../docker

# Build deb-s3 and equivs-build CLI utility tool images
docker build -t deb-s3 -f Dockerfile.deb-s3 .
docker build -t equivs-build -f Dockerfile.equivs-build .

# Build the nvidia-opencv deb meta-package
cp ${META_DIR}/nvidia-opencv ${BUILD_DIR}/
docker run --rm -it \
  -v ${BUILD_DIR}:/build \
  equivs-build --arch arm64 /build/nvidia-opencv

# Build the nvidia-jetpack deb meta-package
cp ${META_DIR}/nvidia-jetpack ${BUILD_DIR}/
docker run --rm -it \
  -v ${BUILD_DIR}:/build \
  equivs-build --arch arm64 /build/nvidia-jetpack

# Upload the OpenCV deb package to S3
docker run --rm -it \
  -v ~/.aws:/root/.aws \
  -v ${BUILD_DIR}:/build \
  -e GPG_PRIVATE_KEY="${GPG_PRIVATE_KEY}" \
  deb-s3 upload --bucket "${S3_BUCKET}" --arch arm64 --prefix jetson/common --codename=r32.7 --sign ${GPG_PUBLIC_KEY} /build/${DEB_FILENAME}

# Upload the nvidia-opencv deb package to S3
docker run --rm -it \
  -v ~/.aws:/root/.aws \
  -v ${BUILD_DIR}:/build \
  -e GPG_PRIVATE_KEY="${GPG_PRIVATE_KEY}" \
  deb-s3 upload --bucket "${S3_BUCKET}" --arch arm64 --prefix jetson/common --codename=r32.7 --sign ${GPG_PUBLIC_KEY} /build/nvidia-opencv_${JETPACK_VERSION}_arm64.deb

# Upload the nvidia-jetpack deb package to S3
docker run --rm -it \
  -v ~/.aws:/root/.aws \
  -v ${BUILD_DIR}:/build \
  -e GPG_PRIVATE_KEY="${GPG_PRIVATE_KEY}" \
  deb-s3 upload --bucket "${S3_BUCKET}" --arch arm64 --prefix jetson/common --codename=r32.7 --sign ${GPG_PUBLIC_KEY} /build/nvidia-jetpack_${JETPACK_VERSION}_arm64.deb
