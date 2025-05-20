cmake_minimum_required(VERSION 3.15)
project(ValgrindPackage LANGUAGES C CXX)

include(ExternalProject)
include(CPack) # Still needed for 'ninja package' or 'make package'
include(ProcessorCount) # Include ProcessorCount module

# Set variables for Valgrind version and directories
set(VALGRIND_VERSION "3.25.1")
set(VALGRIND_SOURCE_DIR "/usr/src/valgrind-${VALGRIND_VERSION}")
set(VALGRIND_BUILD_DIR "${CMAKE_BINARY_DIR}/valgrind-build")
set(VALGRIND_STAGED_INSTALL_DIR "${CMAKE_BINARY_DIR}/valgrind-install") # Intermediate install dir

# CMAKE_INSTALL_PREFIX will be set by the calling script (e.g., to /usr)
# This is the prefix CPack will use for the final package structure.

# External project to build Valgrind
ExternalProject_Add(
  valgrind # Target name
  SOURCE_DIR ${VALGRIND_SOURCE_DIR}
  BINARY_DIR ${VALGRIND_BUILD_DIR}
  CONFIGURE_COMMAND ${VALGRIND_SOURCE_DIR}/configure
                      --prefix=${VALGRIND_STAGED_INSTALL_DIR} # Install to our intermediate dir
                      --enable-lto=yes
                      --disable-dependency-tracking
  BUILD_COMMAND make -j8
  INSTALL_COMMAND make install # This installs to VALGRIND_STAGED_INSTALL_DIR
  BUILD_IN_SOURCE 0
  DOWNLOAD_COMMAND ""
  UPDATE_COMMAND ""
  PATCH_COMMAND ""
  TEST_COMMAND ""
)

# This custom target ensures valgrind external project is built.
add_custom_target(valgrind_built ALL DEPENDS valgrind)

# Now, explicitly install the contents of VALGRIND_STAGED_INSTALL_DIR
# into the locations CPack will use (governed by CMAKE_INSTALL_PREFIX).
# The DESTINATION "." installs to the root of CMAKE_INSTALL_PREFIX.
# So, if CMAKE_INSTALL_PREFIX is /usr, files from VALGRIND_STAGED_INSTALL_DIR/bin
# will go to /usr/bin in the package, etc.
install(
  DIRECTORY ${VALGRIND_STAGED_INSTALL_DIR}/
  DESTINATION .
  USE_SOURCE_PERMISSIONS
  COMPONENT Runtime # Component name, can be anything, often Runtime or Unspecified
)

# CPack settings are passed by the container script.
# The install(DIRECTORY ...) command above is what CPack will now use
# to populate the package from the VALGRIND_STAGED_INSTALL_DIR.
