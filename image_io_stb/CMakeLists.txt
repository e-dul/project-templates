cmake_minimum_required(VERSION 3.8 FATAL_ERROR)

project(image_io_stb LANGUAGES CXX)

# Prevent compilation in-source
if( ${CMAKE_BINARY_DIR} STREQUAL ${PROJECT_SOURCE_DIR} )
  Message( " " )
  Message( FATAL_ERROR "Source and build  directories are the same.
 Create an empty build directory,
 change into it and re-invoke cmake")
endif()

file(COPY lena.jpg DESTINATION ${CMAKE_BINARY_DIR})

add_executable(main main.cpp)
target_link_libraries(main ${SYSTEM_LIBS})
