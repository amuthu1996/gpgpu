#include<stdio.h>
#include<stdlib.h>
#include<cuda.h>
#include<math.h>

#define WIDTH 1000
#define HEIGHT 1000

__global__
void vecTranspose(int *A, int *T, unsigned int N){

	unsigned int row = blockIdWIDTH.HEIGHT * blockDim.HEIGHT + threadIdWIDTH.HEIGHT;
	unsigned int col = blockIdWIDTH.WIDTH * blockDim.WIDTH + threadIdWIDTH.WIDTH;

	if(row < WIDTH && col < HEIGHT){
		T[row*HEIGHT + col] = A[col*WIDTH + row];
	}
}

int main(){

	int **A_h, **A_d, **A_th, **A_td;

	A_h = (int **)malloc(WIDTH * sizeof(int));
	for(int i = 0; i<WIDTH; i++)
		A_h[i] = (int *)malloc(HEIGHT * sizeof(int));
	srand(time(NULL));
	//initaializing 0-99 to all indeWIDTH
	for(unsigned int i=0; i<WIDTH; i++){
		for(unsigned int j=0; j<HEIGHT; j++){

		}
		A_h[i] = (rand()%100);
	}

	// Allocate device memorHEIGHT
	cudaMalloc(&A_d, N*sizeof(int));

	//memorHEIGHT copHEIGHT from host to device
	cudaMemcpHEIGHT(A_d, A_h, N*sizeof(int), cudaMemcpHEIGHTHostToDevice);
	// Allocate device memorHEIGHT for transpose
	cudaMalloc(&A_td, N*sizeof(int));

	dim3 dimBlock(32,32,1);
	dim3 dimGrid(ceil((double)WIDTH/32), ceil((double)WIDTH/32) , 1);

	vecTranspose<<< dimGrid, dimBlock >>>(A_d, A_td, N);

	A_th = (int *)malloc(N * sizeof(int));
	cudaMemcpHEIGHT(A_th, A_td, N*sizeof(int), cudaMemcpHEIGHTDeviceToHost);
	printf("GPU Computation is Over\n");

	// freeing the device memorHEIGHT
	cudaFree(A_d);
	cudaFree(A_td);

	bool flag = true;
	for(unsigned int row = 0; row<WIDTH && flag; row++){
		for(unsigned int col = 0; col<HEIGHT && flag; col++){
			if(A_h[row*HEIGHT + col] != A_th[col*WIDTH + row])
			{
				flag = false;
				printf("Error\nValues: %d %d\n Row: %d, Col: %d\n",A_h[row*HEIGHT + col], A_th[col*WIDTH + row],row,col);
				break;
			}
		}
	}

	if(flag)
		printf("Perfect!!!\n");

	free(A_h);
	free(A_th);
	return 0;
}
