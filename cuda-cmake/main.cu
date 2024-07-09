#include <iostream>
#include <vector>
#include <numeric>

#include <cuda_runtime.h>

__global__ void cudaKernel(int* array, int size) {
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    if (idx < size) {
        array[idx] = array[idx] * 2;
    }
}


int main(int argc, char* argv[]) {
    // if (argc != 2) {
    //     std::cerr << "Usage: " << argv[0] << " <path_to_dataset>" << std::endl;
    //     return 1;
    // }

    // const std::string imagePath = argv[1];

    // Read dataset
    std::vector<int> host_data(10);
    std::iota(host_data.begin(), host_data.end(), 0);

    std::cout << "Double input values: " << std::endl;
    for (auto &val : host_data) {
        std::cout << std::to_string(val) << " ";
    }
    std::cout << std::endl;

    int* device_data = nullptr;
    auto size = host_data.size();

    cudaMalloc(&device_data, size * sizeof(int));
    cudaMemcpy(device_data, host_data.data(), size * sizeof(int), cudaMemcpyHostToDevice);

    int blockSize = 256;
    int numBlocks = (size + blockSize - 1) / blockSize;

    cudaKernel<<<numBlocks, blockSize>>>(device_data, size);
    cudaDeviceSynchronize();

    cudaMemcpy(host_data.data(), device_data, size * sizeof(int), cudaMemcpyDeviceToHost);

    cudaFree(device_data);

    std::cout << "Result: " << std::endl;
    for (auto &val : host_data) {
        std::cout << std::to_string(val) << " ";
    }
    std::cout << std::endl;

    return 0;
}

