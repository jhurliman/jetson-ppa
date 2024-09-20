# Build Eigen and create a libeigen3-dev deb package

# This folder is bind-mounted from the host machine
cd /build

cmake \
  -G Ninja \
  -D BUILD_TESTING=OFF \
  -D EIGEN_BUILD_DOC=OFF \
  -D CMAKE_BUILD_TYPE=Release \
  -D CMAKE_C_FLAGS="-march=armv8-a+crc" \
  -D CMAKE_CXX_FLAGS="-march=armv8-a+crc" \
  -D CMAKE_INSTALL_PREFIX=/usr \
  -D CMAKE_INSTALL_RPATH_USE_LINK_PATH=ON \
  -D CPACK_PACKAGE_CONTACT="John Hurliman <jhurliman@jhurliman.org>" \
  -D CPACK_PACKAGE_VERSION="3.4.0" \
  -D CPACK_PACKAGE_RELEASE=1 \
  -D CPACK_PACKAGE_DESCRIPTION="Eigen is a C++ template library for linear algebra: matrices, vectors, numerical solvers, and related algorithms." \
  -D CPACK_DEBIAN_PACKAGE_SHLIBDEPS=ON \
  -D CPACK_DEBIAN_FILE_NAME="DEB-DEFAULT" \
  /usr/src

# Package Eigen
cpack -G DEB
