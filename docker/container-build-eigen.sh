# Build and package Eigen and create a libeigen3-dev deb package

# Increment this whenever the build script or Dockerfile changes
CPACK_PACKAGE_RELEASE=1

# This folder is bind-mounted from the host machine
cd /build

cmake \
  -G Ninja \
  -D BUILD_TESTING=OFF \
  -D EIGEN_BUILD_DOC=OFF \
  -D CMAKE_BUILD_TYPE=Release \
  -D CMAKE_INSTALL_PREFIX=/usr \
  -D CMAKE_INSTALL_RPATH_USE_LINK_PATH=ON \
  -D CPACK_PACKAGE_CONTACT="John Hurliman <jhurliman@jhurliman.org>" \
  -D CPACK_PACKAGE_VERSION="3.4.0" \
  -D CPACK_PACKAGE_RELEASE="${CPACK_PACKAGE_RELEASE}" \
  -D CPACK_DEBIAN_PACKAGE_RELEASE="ppa${CPACK_PACKAGE_RELEASE}" \
  -D CPACK_PACKAGE_DESCRIPTION="Eigen is a C++ template library for linear algebra: matrices, vectors, numerical solvers, and related algorithms." \
  -D CPACK_DEBIAN_PACKAGE_SHLIBDEPS=ON \
  -D CPACK_DEBIAN_FILE_NAME="DEB-DEFAULT" \
  /usr/src

# Package Eigen
cpack -G DEB
