#include <iostream>
#include <vector>
#include <numeric>

#include "kernel.h"

int main(int argc, char* argv[]) {
    std::vector<int> host_data(10);
    std::iota(host_data.begin(), host_data.end(), 0);

    std::cout << "Double input values: " << std::endl;
    for (auto &val : host_data) {
        std::cout << std::to_string(val) << " ";
    }
    std::cout << std::endl;

    // Launch CUDA kernel from the library
    launchCudaKernel(host_data);

    std::cout << "Result: " << std::endl;
    for (auto &val : host_data) {
        std::cout << std::to_string(val) << " ";
    }
    std::cout << std::endl;

    return 0;
}

