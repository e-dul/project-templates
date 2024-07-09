# Based on https://github.com/NVIDIA/cccl/tree/main/examples/example_project and https://github.com/robertmaynard/code-samples/blob/master/posts/cmake/CMakeLists.txt
# https://forums.developer.nvidia.com/t/how-to-link-cuda-dynamic-libraries-using-cmake/239003

# CMakeLists.txt
cmake_minimum_required(VERSION 3.8 FATAL_ERROR)

project(cuda-mean-shift LANGUAGES CXX CUDA)


if(NOT DEFINED CMAKE_CUDA_ARCHITECTURES)
  set(CMAKE_CUDA_ARCHITECTURES 86)
endif()

# Add the main executable
add_executable(main main.cu)
target_compile_features(main PRIVATE cxx_std_17 cuda_std_14)

