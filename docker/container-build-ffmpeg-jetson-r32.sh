# Build and package ffmpeg for Jetson

# Increment this whenever the build script or Dockerfile changes
CPACK_PACKAGE_RELEASE=1

# This folder is bind-mounted from the host machine
cd /build

cmake \
  -G Ninja \
  -D CMAKE_BUILD_TYPE=Release \
  -D CMAKE_C_FLAGS="-march=armv8.2-a+crc" \
  -D CMAKE_INSTALL_PREFIX=/usr \
  -D CPACK_BINARY_DEB=ON \
  -D CPACK_DEBIAN_PACKAGE_REPLACES="libavcodec-dev, libavdevice-dev, libavformat-dev, libavfilter-dev, libavutil-dev, libswresample-dev, libswscale-dev, libavcodec57, libavdevice57, libavformat57, libavfilter6, libavutil55, libswresample, libswscale" \
  -D CPACK_DEBIAN_PACKAGE_PROVIDES="libavcodec-dev, libavdevice-dev, libavformat-dev, libavfilter-dev, libavutil-dev, libswresample-dev, libswscale-dev, libavcodec58, libavdevice58, libavformat58, libavfilter7, libavutil56, libswresample, libswscale" \
  -D CPACK_DEBIAN_PACKAGE_MAINTAINER="John Hurliman" \
  -D CPACK_DEBIAN_PACKAGE_NAME="ffmpeg" \
  -D CPACK_GENERATOR=DEB \
  -D CPACK_SOURCE_GENERATOR=DEB \
  -D CPACK_PACKAGE_CONTACT="John Hurliman <jhurliman@jhurliman.org>" \
  -D CPACK_PACKAGE_NAME="ffmpeg" \
  -D CPACK_PACKAGE_VERSION="4.4.2" \
  -D CPACK_PACKAGE_RELEASE="${CPACK_PACKAGE_RELEASE}" \
  -D CPACK_PACKAGE_DESCRIPTION="FFmpeg is the leading multimedia framework, able to decode, encode, transcode, mux, demux, stream, filter and play pretty much anything that humans and machines have created. It supports the most obscure ancient formats up to the cutting edge." \
  -D CPACK_DEBIAN_PACKAGE_SHLIBDEPS=ON \
  -D CPACK_DEBIAN_FILE_NAME="DEB-DEFAULT" \
  /usr/src

# Build ffmpeg and create a deb package
ninja package
