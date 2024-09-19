# Build ceres-solver

# This folder is bind-mounted from the host machine
cd /build

# ceres-solver repo hardcodes CUDA_ARCHITECTURES to 50, 60, 70, 80. Unfortunately, arch 80 can't be
# built from CUDA 10.2 on Jetson. Target only the CUDA architectures we care about for Jetson
sed -i 's/set(CMAKE_CUDA_ARCHITECTURES "50;60;70;80")/set(CMAKE_CUDA_ARCHITECTURES "53;62;72")/' /usr/src/ceres-solver/CMakeLists.txt

cmake \
  -G Ninja \
  -D MINIGLOG=ON \
  -D GFLAGS=OFF \
  -D SUITESPARSE=OFF \
  -D USE_CUDA=ON \
  -D BUILD_TESTING=OFF \
  -D BUILD_EXAMPLES=OFF \
  -D BUILD_BENCHMARKS=OFF \
  -D BUILD_SHARED_LIBS=ON \
  -D PROVIDE_UNINSTALL_TARGET=OFF \
  -D CMAKE_BUILD_TYPE=RELEASE \
  -D CMAKE_C_FLAGS="-march=armv8-a+crc" \
  -D CMAKE_CXX_FLAGS="-march=armv8-a+crc" \
  -D CMAKE_INSTALL_PREFIX=/usr \
  -D CMAKE_INSTALL_RPATH_USE_LINK_PATH=ON \
  -D CPACK_BINARY_DEB=ON \
  -D CPACK_DEBIAN_PACKAGE_DEPENDS="libblas-dev, libeigen3-dev, liblapack-dev, liblapacke-dev" \
  -D CPACK_DEBIAN_PACKAGE_MAINTAINER="John Hurliman" \
  -D CPACK_DEBIAN_PACKAGE_NAME=libceres-dev \
  -D CPACK_GENERATOR=DEB \
  -D CPACK_SOURCE_GENERATOR=DEB \
  -D CPACK_PACKAGE_CONTACT="John Hurliman <jhurliman@jhurliman.org>" \
  -D CPACK_PACKAGE_VERSION="2.2.0" \
  -D CPACK_PACKAGE_RELEASE=1 \
  -D CPACK_PACKAGE_DESCRIPTION="Ceres Solver is an open source C++ library for modeling and solving large, complicated optimization problems. It is a feature rich, mature and performant library which has been used in production at Google since 2010." \
  -D CPACK_DEBIAN_PACKAGE_SHLIBDEPS=ON \
  -D CPACK_DEBIAN_FILE_NAME="DEB-DEFAULT" \
  /usr/src

# Build ceres and create a libceres-dev deb package
ninja package
