#!/bin/bash
set -e

# Increment this whenever the build script or Dockerfile changes
CPACK_PACKAGE_RELEASE=1
VALGRIND_VERSION="3.25.1"

# This folder is bind-mounted from the host machine, e.g., to $(pwd)/debs
# The CMakeLists.txt is expected in /usr/src (copied by Dockerfile)
# The source for valgrind is also in /usr/src/valgrind-VERSION (downloaded by Dockerfile)

# Create a build directory inside the container
BUILD_DIR="/build"
mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}

# Configure, build, and package
# CMAKE_INSTALL_PREFIX is crucial. Valgrind's ./configure --prefix will use this.
# CPack will then package files from this prefix.
cmake \
  -G Ninja \
  -D CMAKE_BUILD_TYPE=Release \
  -D CMAKE_INSTALL_PREFIX=/usr \
  -D CPACK_BINARY_DEB=ON \
  -D CPACK_PACKAGE_NAME="valgrind" \
  -D CPACK_PACKAGE_VERSION="${VALGRIND_VERSION}" \
  -D CPACK_PACKAGE_RELEASE="${CPACK_PACKAGE_RELEASE}" \
  -D CPACK_PACKAGE_ARCHITECTURE="arm64" \
  -D CPACK_DEBIAN_PACKAGE_MAINTAINER="John Hurliman <jhurliman@jhurliman.org>" \
  -D CPACK_PACKAGE_DESCRIPTION="Valgrind dynamic analysis tools for ARM64 (Jetson)" \
  -D CPACK_DEBIAN_PACKAGE_SHLIBDEPS=ON \
  -D CPACK_DEBIAN_PACKAGE_GENERATE_SHLIBS=ON \
  -D CPACK_SET_DESTDIR=ON \
  -D CPACK_DEBIAN_FILE_NAME="DEB-DEFAULT" \
  -D VALGRIND_VERSION="${VALGRIND_VERSION}" \
  /usr/src # Path to the CMakeLists.txt (which is build-valgrind.cmake)

ninja package

# The .deb package will be in ${BUILD_DIR}
echo "Valgrind .deb package created in ${BUILD_DIR}"
