#include "kernel.h"

#include <cuda_runtime.h>

__global__ void cudaKernel(int* array, int size) {
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    if (idx < size) {
        array[idx] = array[idx] * 2;
    }
}

void launchCudaKernel(std::vector<int> & data) {
    int* device_data = nullptr;
    auto size = data.size();

    cudaMalloc(&device_data, size * sizeof(int));
    cudaMemcpy(device_data, data.data(), size * sizeof(int), cudaMemcpyHostToDevice);

    int blockSize = 256;
    int numBlocks = (size + blockSize - 1) / blockSize;

    cudaKernel<<<numBlocks, blockSize>>>(device_data, size);
    cudaDeviceSynchronize();

    cudaMemcpy(data.data(), device_data, size * sizeof(int), cudaMemcpyDeviceToHost);

    cudaFree(device_data);
}
