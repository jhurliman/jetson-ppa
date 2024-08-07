# Build OpenCV

# This folder is bind-mounted from the host machine
cd /build

cmake \
  -G Ninja \
  -D BUILD_EXAMPLES=OFF \
  -D BUILD_opencv_apps=OFF \
  -D BUILD_opencv_highgui=OFF \
  -D BUILD_opencv_java=OFF \
  -D BUILD_opencv_java_bindings_generator=OFF \
  -D BUILD_opencv_photo=ON \
  -D BUILD_opencv_python_bindings_generator=OFF \
  -D BUILD_opencv_python2=OFF \
  -D BUILD_opencv_python3=OFF \
  -D BUILD_PERF_TESTS=OFF \
  -D BUILD_SHARED_LIBS=ON \
  -D BUILD_TBB=ON \
  -D BUILD_TESTS=OFF \
  -D BUILD_TIFF=ON \
  -D CMAKE_BUILD_TYPE=RELEASE \
  -D CMAKE_C_FLAGS="-march=armv8-a+crc" \
  -D CMAKE_CXX_FLAGS="-march=armv8-a+crc" \
  -D CMAKE_INSTALL_PREFIX=/usr \
  -D CMAKE_INSTALL_RPATH_USE_LINK_PATH=ON \
  -D CPACK_BINARY_DEB=ON \
  -D CPACK_COMPONENTS_ALL=dev \
  -D CPACK_DEBIAN_PACKAGE_DEPENDS="gfortran, libatlas-base-dev, libavcodec-dev, libavformat-dev, \
     libblas-dev, libceres-dev, libeigen3-dev, libfaac-dev, libfreetype6-dev, libgflags-dev, \
     libglew-dev, libgoogle-glog-dev, libharfbuzz-dev, libhdf5-dev, libjpeg-dev, libjpeg-turbo8-dev, \
     libjpeg8-dev, liblapack-dev, liblapacke-dev, libmp3lame-dev, libopenblas-dev, \
     libopencore-amrnb-dev, libopencore-amrwb-dev, libpng-dev, libpostproc-dev, libprotobuf-dev, \
     libswresample-dev, libswscale-dev, libtbb-dev, libtesseract-dev, libtheora-dev, \
     libtiff-dev, libv4l-dev, libvorbis-dev, libx264-dev, libxine2-dev, libxvidcore-dev, \
     protobuf-compiler, v4l-utils" \
  -D CPACK_DEBIAN_PACKAGE_MAINTAINER="John Hurliman" \
  -D CPACK_DEBIAN_PACKAGE_NAME=libopencv \
  -D CPACK_GENERATOR=DEB \
  -D CPACK_SOURCE_GENERATOR=DEB \
  -D CUDA_ARCH_BIN="5.3,6.2,7.2" \
  -D CUDA_ARCH_PTX="" \
  -D CUDA_FAST_MATH=ON \
  -D ENABLE_CUDA_FIRST_CLASS_LANGUAGE=ON \
  -D ENABLE_FAST_MATH=ON \
  -D ENABLE_NEON=ON \
  -D INSTALL_C_EXAMPLES=OFF \
  -D INSTALL_PYTHON_EXAMPLES=OFF \
  -D OPENCV_DNN_CUDA=ON \
  -D OPENCV_ENABLE_NONFREE=OFF \
  -D OPENCV_ENABLE_PKG_CONFIG=ON \
  -D OPENCV_EXTRA_MODULES_PATH=/usr/src/opencv_contrib/modules \
  -D OPENCV_GENERATE_PKGCONFIG=ON \
  -D WITH_CUBLAS=ON \
  -D WITH_CUDA=ON \
  -D WITH_CUDNN=ON \
  -D WITH_EIGEN=ON \
  -D WITH_FREETYPE=ON \
  -D WITH_HARFBUZZ=ON \
  -D WITH_FFMPEG=ON \
  -D WITH_GSTREAMER=ON \
  -D WITH_GTK=OFF \
  -D WITH_GTK_2_X=OFF \
  -D WITH_LIBV4L=ON \
  -D WITH_NVCUVENC=OFF \
  -D WITH_NVCUVID=OFF \
  -D WITH_OPENCL=OFF \
  -D WITH_OPENMP=ON \
  -D WITH_PROTOBUF=ON \
  -D WITH_QT=OFF \
  -D WITH_TBB=ON \
  -D WITH_V4L=ON \
  /usr/src/opencv

# Build OpenCV and create a libopencv-dev deb package
ninja package

# Create a OpenCV source package (currently unused)
# ninja package_source
