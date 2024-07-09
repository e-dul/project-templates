# Based on https://github.com/NVIDIA/cccl/tree/main/examples/example_project and https://github.com/robertmaynard/code-samples/blob/master/posts/cmake/CMakeLists.txt
# https://forums.developer.nvidia.com/t/how-to-link-cuda-dynamic-libraries-using-cmake/239003

# CMakeLists.txt
cmake_minimum_required(VERSION 3.8 FATAL_ERROR)

project(cuda-mean-shift LANGUAGES CXX CUDA)

include(cmake/CPM.cmake)

# This will automatically clone CCCL from GitHub and make the exported cmake targets available
CPMAddPackage(
    NAME CCCL
    GITHUB_REPOSITORY nvidia/cccl
    GIT_TAG main # Fetches the latest commit on the main branch
)

if(NOT DEFINED CMAKE_CUDA_ARCHITECTURES)
  set(CMAKE_CUDA_ARCHITECTURES 86)
endif()

IF (WIN32)
  set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)
ENDIF()

# Add the CUDA kernels library
add_library(cuda_kernel_lib SHARED kernel.h kernel.cu)
target_compile_features(cuda_kernel_lib PRIVATE cuda_std_14)
target_link_libraries(cuda_kernel_lib PRIVATE CCCL::CCCL)
set_target_properties(cuda_kernel_lib PROPERTIES
CUDA_RUNTIME_LIBRARY Shared
CUDA_SEPARABLE_COMPILATION ON
)

# Add the main executable
add_executable(main main.cpp)
target_compile_features(main PRIVATE cxx_std_17)
target_link_libraries(main cuda_kernel_lib CCCL::CCCL)

