#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>
#include <cuda.h>

__global__ void cuda_hello(){
	printf("Hello World du GPU\n");
}

int main(void) {
	printf("Hello World du CPU\n");
	cuda_hello<<<1,1>>>();
    cudaDeviceSynchronize();
    printf("Fin du programme\n");
	return EXIT_SUCCESS;
}