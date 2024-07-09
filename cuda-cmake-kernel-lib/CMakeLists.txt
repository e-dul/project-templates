# Based on https://github.com/NVIDIA/cccl/tree/main/examples/example_project and https://github.com/robertmaynard/code-samples/blob/master/posts/cmake/CMakeLists.txt
# https://forums.developer.nvidia.com/t/how-to-link-cuda-dynamic-libraries-using-cmake/239003

# CMakeLists.txt
cmake_minimum_required(VERSION 3.8 FATAL_ERROR)

project(cuda-mean-shift LANGUAGES CXX CUDA)


if(NOT DEFINED CMAKE_CUDA_ARCHITECTURES)
  set(CMAKE_CUDA_ARCHITECTURES 86)
endif()

# Add the CUDA kernels library
add_library(cuda_kernel_lib SHARED kernel.h kernel.cu)
target_compile_features(cuda_kernel_lib PRIVATE cuda_std_14)
set_target_properties(cuda_kernel_lib PROPERTIES
CUDA_RUNTIME_LIBRARY Shared
CUDA_SEPARABLE_COMPILATION ON
)

# Add the main executable
add_executable(main main.cpp)
target_compile_features(main PRIVATE cxx_std_17)
target_link_libraries(main cuda_kernel_lib)

