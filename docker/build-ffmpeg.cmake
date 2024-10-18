cmake_minimum_required(VERSION 3.15)
project(FFmpegPackage LANGUAGES C)

include(CPack)
include(ExternalProject)

# Set variables for FFmpeg version and directories
set(FFMPEG_VERSION "4.4.2")
set(FFMPEG_SOURCE_DIR "/usr/src/ffmpeg-${FFMPEG_VERSION}")
set(FFMPEG_INSTALL_DIR "${CMAKE_BINARY_DIR}/ffmpeg-install")
set(FFMPEG_BUILD_DIR "${CMAKE_BINARY_DIR}/ffmpeg-build")
set(CMAKE_LIBRARY_ARCHITECTURE "aarch64-linux-gnu")

# External project to build FFmpeg using existing source
ExternalProject_Add(
  ffmpeg
  SOURCE_DIR ${FFMPEG_SOURCE_DIR}
  BINARY_DIR ${FFMPEG_BUILD_DIR}
  CONFIGURE_COMMAND ${FFMPEG_SOURCE_DIR}/configure
                      --prefix=/usr
                      --libdir=/usr/lib/${CMAKE_LIBRARY_ARCHITECTURE}
                      --shlibdir=/usr/lib/${CMAKE_LIBRARY_ARCHITECTURE}
                      --pkgconfigdir=/usr/lib/${CMAKE_LIBRARY_ARCHITECTURE}/pkgconfig
                      --incdir=/usr/include
                      --bindir=/usr/bin
                      --enable-shared
                      --disable-static
                      --extra-cflags="-march=armv8.2-a+crc"
  BUILD_COMMAND make -j8
  INSTALL_COMMAND DESTDIR=${FFMPEG_INSTALL_DIR} make install
  BUILD_IN_SOURCE 0
  DOWNLOAD_COMMAND ""
  UPDATE_COMMAND ""
  PATCH_COMMAND ""
  TEST_COMMAND ""
)

# Ensure the build happens when we build the main project
add_custom_target(ffmpeg_build ALL DEPENDS ffmpeg)

# Install FFmpeg binaries and libraries
install(
  DIRECTORY ${FFMPEG_INSTALL_DIR}/
  DESTINATION /
  USE_SOURCE_PERMISSIONS
  FILES_MATCHING PATTERN "*"
)
