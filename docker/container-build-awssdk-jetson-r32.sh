# Build ceres-solver

# This folder is bind-mounted from the host machine
cd /build

cmake \
  -G Ninja \
  -D BUILD_ONLY="transfer;s3" \
  -D ENABLE_TESTING=OFF \
  -D BUILD_SHARED_LIBS=ON \
  -D CPP_STANDARD=17 \
  -D USE_OPENSSL=ON \
  -D CMAKE_BUILD_TYPE=Release \
  -D CMAKE_C_FLAGS="-march=armv8-a+crc" \
  -D CMAKE_CXX_FLAGS="-march=armv8-a+crc" \
  -D CMAKE_INSTALL_PREFIX=/usr \
  -D CMAKE_INSTALL_RPATH_USE_LINK_PATH=ON \
  -D CPACK_BINARY_DEB=ON \
  -D CPACK_DEBIAN_PACKAGE_DEPENDS="libcurl4-openssl-dev, libssl-dev" \
  -D CPACK_DEBIAN_PACKAGE_MAINTAINER="John Hurliman" \
  -D CPACK_DEBIAN_PACKAGE_NAME=aws-sdk-cpp \
  -D CPACK_GENERATOR=DEB \
  -D CPACK_SOURCE_GENERATOR=DEB \
  -D CPACK_PACKAGE_CONTACT="John Hurliman <jhurliman@jhurliman.org>" \
  -D CPACK_PACKAGE_VERSION="1.11.409" \
  -D CPACK_PACKAGE_RELEASE=1 \
  -D CPACK_PACKAGE_DESCRIPTION="AWS SDK for C++" \
  -D CPACK_DEBIAN_PACKAGE_SHLIBDEPS=ON \
  -D CPACK_DEBIAN_FILE_NAME="DEB-DEFAULT" \
  /usr/src

# Build aws-sdk-cpp and create a deb package
ninja package
