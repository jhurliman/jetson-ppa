# Build and package OpenCV for x64

# Increment this whenever the build script or Dockerfile changes
CPACK_PACKAGE_RELEASE=1

# This folder is bind-mounted from the host machine
cd /build

cmake \
  -G Ninja \
  -D BUILD_EXAMPLES=OFF \
  -D BUILD_opencv_apps=OFF \
  -D BUILD_opencv_gapi=OFF \
  -D BUILD_opencv_highgui=OFF \
  -D BUILD_opencv_java=OFF \
  -D BUILD_opencv_java_bindings_generator=OFF \
  -D BUILD_opencv_photo=ON \
  -D BUILD_opencv_python_bindings_generator=OFF \
  -D BUILD_opencv_python2=OFF \
  -D BUILD_opencv_python3=OFF \
  -D BUILD_PERF_TESTS=OFF \
  -D BUILD_SHARED_LIBS=ON \
  -D BUILD_TBB=OFF \
  -D BUILD_TESTS=OFF \
  -D BUILD_TIFF=ON \
  -D CMAKE_BUILD_TYPE=Release \
  -D CMAKE_INSTALL_PREFIX=/usr \
  -D CMAKE_INSTALL_RPATH_USE_LINK_PATH=ON \
  -D CPACK_BINARY_DEB=ON \
  -D CPACK_COMPONENTS_ALL="dev;libs" \
  -D CPACK_DEB_COMPONENT_INSTALL=ON \
  -D CPACK_DEBIAN_PACKAGE_DEPENDS="cuda-runtime-12-0, gfortran, libatlas-base-dev, libavcodec-dev, \
     libavformat-dev, libblas-dev, libceres-dev (= 2.2.0), libcudnn8, libeigen3-dev (= 3.4.0-2ubuntu2), libfaac-dev, libfreetype6-dev, libgflags-dev, \
     libglew-dev, libgoogle-glog-dev, libharfbuzz-dev, libhdf5-dev, libjpeg-dev, libjpeg-turbo8-dev, \
     libjpeg8-dev, liblapack-dev, liblapacke-dev, libmp3lame-dev, libopenblas-dev, \
     libopencore-amrnb-dev, libopencore-amrwb-dev, libpng-dev, libpostproc-dev, libprotobuf-dev, \
     libswresample-dev, libswscale-dev, libtbb-dev, libtesseract-dev, libtheora-dev, \
     libtiff-dev, libv4l-dev, libvorbis-dev, libx264-dev, libxine2-dev, libxvidcore-dev, \
     protobuf-compiler, v4l-utils" \
  -D CPACK_DEBIAN_PACKAGE_MAINTAINER="John Hurliman" \
  -D CPACK_DEBIAN_PACKAGE_NAME=libopencv \
  -D CPACK_PACKAGE_RELEASE="${CPACK_PACKAGE_RELEASE}" \
  -D CPACK_PACKAGE_DESCRIPTION_SUMMARY="Open Computer Vision Library" \
  -D CPACK_PACKAGE_DESCRIPTION="OpenCV (Open Source Computer Vision Library) is an open source computer vision and machine learning software library. OpenCV was built to provide a common infrastructure for computer vision applications and to accelerate the use of machine perception in the commercial products. Being a BSD-licensed product, OpenCV makes it easy for businesses to utilize and modify the code." \
  -D CPACK_PACKAGE_VENDOR="OpenCV Foundation" \
  -D CPACK_PACKAGE_VERSION_MAJOR="4" \
  -D CPACK_PACKAGE_VERSION_MINOR="10" \
  -D CPACK_PACKAGE_VERSION_PATCH="0" \
  -D CPACK_PACKAGE_VERSION="4.10.0" \
  -D CPACK_GENERATOR=DEB \
  -D CPACK_MONOLITHIC_INSTALL=ON \
  -D CPACK_SOURCE_GENERATOR=DEB \
  -D CUDA_ARCH_BIN="5.0,6.0,7.0,8.0" \
  -D CUDA_ARCH_PTX="" \
  -D CUDA_FAST_MATH=ON \
  -D ENABLE_CUDA_FIRST_CLASS_LANGUAGE=ON \
  -D ENABLE_FAST_MATH=ON \
  -D INSTALL_C_EXAMPLES=OFF \
  -D INSTALL_PYTHON_EXAMPLES=OFF \
  -D OPENCV_CUSTOM_PACKAGE_INFO=ON \
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
