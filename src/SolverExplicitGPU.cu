#include "SolverExplicitGPU.h"
#include <cuda.h>
#include <iostream>
// ====================================
// kernel declaration
// ====================================
__global__ void solveGPU(float * vertex,
                Particle *particle,
                float3 *velocity,
                float3 *acceleration,
                float3 *force,
                float3 *partialForce,
                float *mass,
                float3 gravity,
                float3 wind,
                float viscosity,
                float deltaT,
                int size) {

    int gtid = blockIdx.x*blockDim.x+threadIdx.x;
    if (gtid < size) {
        for(int i = 0; i < particle[gtid].nbSpring; i++) {
            force[gtid] = force[gtid] + partialForce[particle[gtid].springs[i]] * particle[gtid].multiplier[i];
        }
        if(mass[gtid] == 0.0f){
            acceleration[gtid] = make_float3(0.f, 0.f, 0.f);
        }else{
            acceleration[gtid] = (force[gtid] / mass[gtid]) + gravity + wind;
        }
        velocity[gtid] = velocity[gtid] + deltaT * (acceleration[gtid] - viscosity * velocity[gtid]);
        vertex[gtid * 8] = vertex[gtid * 8] + deltaT * velocity[gtid].x;
        vertex[gtid * 8 + 1] = vertex[gtid * 8 + 1] + deltaT * velocity[gtid].y;
        vertex[gtid * 8 + 2] = vertex[gtid * 8 + 2] + deltaT * velocity[gtid].z;
        force[gtid] = make_float3(0.f, 0.f, 0.f);
    }
}

__global__ void updateSpringsGPU(float * vertex, float3 * velocity, Spring * springs, float3 * partialForce, int size) {  
    int gtid = blockIdx.x*blockDim.x+threadIdx.x;

    if(gtid < size){
        int A = springs[gtid].PA;
        int B = springs[gtid].PB;

        float3 dPos;
        dPos.x = vertex[A * 8] - vertex[B * 8];
        dPos.y = vertex[A * 8 + 1] - vertex[B * 8 + 1];
        dPos.z = vertex[A * 8 + 2] - vertex[B * 8 + 2];
        float3 dVit = velocity[A] - velocity[B];
        float3 dPosNorm = normalize(dPos);

        float diffLength = length(dPos) - springs[gtid].restLength;
        partialForce[gtid] = (springs[gtid].stiffness * diffLength * dPosNorm) + (springs[gtid].damping * dPos * dot(dVit, dPos));
    }
}


// ====================================
// CPU functions
// ====================================

SolverExplicitGPUData::SolverExplicitGPUData(glm::vec3 gravity, glm::vec3 wind, float viscosity, float deltaT,
        uint VBO,
        std::vector<glm::vec3> * velocity,
        std::vector<glm::vec3> * acceleration,
        std::vector<glm::vec3> * force,
        std::vector<Particle> * particles,
        std::vector<Spring> * spring,
        std::vector<float> * mass) : SolverData(gravity, wind, viscosity, deltaT) {
    this->particleCount = particles->size();
    this->springCount = spring->size();

    this->gravity_gpu = make_float3(gravity.x, gravity.y, gravity.z);
    this->wind_gpu = make_float3(wind.x, wind.y, wind.z);
    this->VBO = VBO;
    cudaGraphicsGLRegisterBuffer(&this->cudaVboResource, this->VBO, cudaGraphicsMapFlagsNone);
    

    cudaMalloc( (void**) &this->vertex, this->particleCount * sizeof(float) * 8 );
    cudaMalloc( (void**) &this->velocity, this->particleCount * sizeof(glm::vec3) );
    cudaMalloc( (void**) &this->partialForce, this->particleCount * sizeof(glm::vec3) );
    cudaMalloc( (void**) &this->acceleration, this->particleCount * sizeof(glm::vec3) );
    cudaMalloc( (void**) &this->force, this->particleCount * sizeof(glm::vec3) );
    cudaMalloc( (void**) &this->mass, this->particleCount * sizeof(float));
    cudaMalloc( (void**) &this->springs, this->springCount * sizeof(Spring) );
    cudaMalloc( (void**) &this->partialForce, this->springCount * sizeof(glm::vec3));
    cudaMalloc( (void**) &this->particles, this->particleCount * sizeof(Particle));


    cudaMemcpy(this->mass,          &(*mass)[0],            this->particleCount * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(this->velocity,      &(*velocity)[0],        this->particleCount * sizeof(glm::vec3), cudaMemcpyHostToDevice);
    cudaMemcpy(this->force,         &(*force)[0],           this->particleCount * sizeof(glm::vec3), cudaMemcpyHostToDevice);
    cudaMemcpy(this->acceleration,  &(*acceleration)[0],    this->particleCount * sizeof(glm::vec3), cudaMemcpyHostToDevice);
    cudaMemcpy(this->springs,       &(*spring)[0],          this->springCount * sizeof(Spring), cudaMemcpyHostToDevice);
    cudaMemcpy(this->particles,     &(*particles)[0],       this->particleCount * sizeof(Particle), cudaMemcpyHostToDevice);
    cudaGraphicsMapResources(1, &cudaVboResource, 0);
}

void printCudaLog() {
    cudaError_t error = cudaGetLastError();
    if (error != cudaSuccess) {
        printf("CUDA error: %s\n", cudaGetErrorString(error));
    }
}

SolverExplicitGPUData::~SolverExplicitGPUData() {
    cudaGraphicsUnmapResources(1, &cudaVboResource, 0);
    cudaGraphicsUnregisterResource(cudaVboResource);
    cudaFree(velocity);
    cudaFree(acceleration);
    cudaFree(force);
    cudaFree(mass);
    cudaFree(springs);
    cudaFree(particles);
    cudaFree(partialForce);
}

SolverExplicitGPU::SolverExplicitGPU(SolverExplicitGPUData * data) : _data(data) {
    type = SolverType::SOLVER_GPU;
}

void SolverExplicitGPU::solve(int tps) {
    int blockSize = 1024;
    int gridSize = (int)ceil((float)_data->particleCount/blockSize);
    
    

    solveGPU<<<gridSize, blockSize>>>(_data->vertex, _data->particles, _data->velocity, 
        _data->acceleration, _data->force, _data->partialForce, 
        _data->mass, _data->gravity_gpu, _data->wind_gpu, 
        _data->viscosity, _data->deltaT, _data->particleCount);
}

void SolverExplicitGPU::updateSprings() {
    int blockSize = 1024;
    int gridSize = (int)ceil((float)_data->springCount/blockSize);
    updateSpringsGPU<<<gridSize, blockSize>>>(_data->vertex, _data->velocity, _data->springs, _data->partialForce, _data->springCount);
}



void SolverExplicitGPU::update(int Tps){
    cudaStream_t stream;
    
    cudaGraphicsResourceGetMappedPointer((void**)&(_data->vertex), &(_data->vertexSize), (_data->cudaVboResource));
    updateSprings();
    solve(Tps);
    //cudaDeviceSynchronize();
    cudaStreamSynchronize(stream);
    

}

SolverExplicitGPU::~SolverExplicitGPU() {
    delete _data;
}