# Based on https://gitlab.com/es-de/emulationstation-de/-/blob/a01215a8db801eb69a3db167f49d57094f57f455/external/CImg/examples/CMakeLists.txt
cmake_minimum_required(VERSION 3.8 FATAL_ERROR)

project(image_io_cimg LANGUAGES CXX)

# Prevent compilation in-source
if( ${CMAKE_BINARY_DIR} STREQUAL ${PROJECT_SOURCE_DIR} )
  Message( " " )
  Message( FATAL_ERROR "Source and build  directories are the same.
 Create an empty build directory,
 change into it and re-invoke cmake")
endif()


# To use PKG_CHECK_MODULES to find some optional packages
find_package(PkgConfig)

FIND_PACKAGE(JPEG)
FIND_PACKAGE(PNG)
FIND_PACKAGE(ZLIB)

if(JPEG_FOUND)
  # Flags to enable native support for JPEG image files, using the JPEG library.
  # ( http://www.ijg.org/ )
  SET(CIMG_JPEG_CCFLAGS  -Dcimg_use_jpeg)
  get_filename_component(JPEG_LIB_DIRS ${JPEG_LIBRARIES} PATH)
  SET(CIMG_CFLAGS "${CIMG_CFLAGS} ${CIMG_JPEG_CCFLAGS}")
  link_directories(${JPEG_LIB_DIRS})
  include_directories(${JPEG_INCLUDE_DIR})
  SET(CIMG_DEPS ${CIMG_DEPS} ${JPEG_LIBRARIES})
endif()

if (ZLIB_FOUND)
  SET(CIMG_CFLAGS "${CIMG_CFLAGS} ${CIMG_ZLIB_CCFLAGS}")
  link_directories(${ZLIB_LIB_DIRS})
  include_directories(${ZLIB_INCLUDE_DIR})
  SET(CIMG_DEPS ${CIMG_DEPS} ${ZLIB_LIBRARIES})

  # PNG requires ZLIB
  if(PNG_FOUND)
    # Flags to enable native support for PNG image files, using the PNG library.
    # ( http://www.libpng.org/ )
    SET(CIMG_PNG_CCFLAGS  -Dcimg_use_png)
    SET(CIMG_CFLAGS "${CIMG_CFLAGS} ${CIMG_PNG_CCFLAGS}")
    link_directories(${PNG_LIB_DIRS})
    include_directories(${PNG_INCLUDE_DIR})
    SET(CIMG_DEPS ${CIMG_DEPS} ${PNG_LIBRARIES})
  endif()
endif()

if(NOT WIN32)
  FIND_PACKAGE(X11)
  FIND_PACKAGE(Threads REQUIRED)
  SET(CIMG_DEPS ${CIMG_DEPS} ${CMAKE_THREAD_LIBS_INIT})

  if(X11_FOUND)
    link_directories(${X11_LIB_DIRS})
    include_directories(${X11_INCLUDE_DIR})
    SET(CIMG_DEPS ${CIMG_DEPS} ${X11_LIBRARIES})
  endif()
endif()

# Add CIMG Flags to Compilation Flags
SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${CIMG_CFLAGS}")

file(COPY lena.jpg DESTINATION ${CMAKE_BINARY_DIR})

add_executable(main main.cpp)
target_link_libraries(main ${CIMG_DEPS})
