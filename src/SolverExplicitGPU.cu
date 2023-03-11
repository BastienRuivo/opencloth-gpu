#include "SolverExplicitGPU.h"
#include <cuda.h>
#include <iostream>
#define GLM_COMPILER 0
// ====================================
// kernel declaration
// ====================================
__global__
void solveGPU(float * vertex,
                Particle *particle,
                glm::vec3 *velocity,
                glm::vec3 *acceleration,
                glm::vec3 *force,
                glm::vec3 *partialForce,
                float *mass,
                glm::vec3 gravity,
                glm::vec3 wind,
                float viscosity,
                float deltaT,
                int size) {

    int gtid = blockIdx.x*blockDim.x+threadIdx.x;
    if (gtid < size) {
        for(int i = 0; i < particle[gtid].nbSpring; i++) {
            if(particle[gtid].springs[i] != -1) {
                if(particle[gtid].isNegative[i])
                    force[gtid] = force[gtid] - partialForce[particle[gtid].springs[i]];
                else
                    force[gtid] = force[gtid] + partialForce[particle[gtid].springs[i]];
            }
        }
        if(mass[gtid] == 0.0f){
            acceleration[gtid] = glm::vec3(0.0f);
        }else{
            acceleration[gtid] = (force[gtid] / mass[gtid]) + gravity + wind;
        }
        velocity[gtid] = velocity[gtid] + deltaT * (acceleration[gtid] - viscosity * velocity[gtid]);

        vertex[gtid * 8] = vertex[gtid * 8] + deltaT * velocity[gtid].x;
        vertex[gtid * 8 + 1] = vertex[gtid * 8 + 1] + deltaT * velocity[gtid].y;
        vertex[gtid * 8 + 2] = vertex[gtid * 8 + 2] + deltaT * velocity[gtid].z;

        force[gtid] = glm::vec3(0.0f);
    }
}

__global__ void updateSpringsGPU(float * vertex, glm::vec3 * velocity, Spring * springs, glm::vec3 * partialForce, int size) {  
    int gtid = blockIdx.x*blockDim.x+threadIdx.x;

    if(gtid < size){
        int A = springs[gtid].PA;
        int B = springs[gtid].PB;

        glm::vec3 dPos;
        dPos.x = vertex[A * 8] - vertex[B * 8];
        dPos.y = vertex[A * 8 + 1] - vertex[B * 8 + 1];
        dPos.z = vertex[A * 8 + 2] - vertex[B * 8 + 2];
        glm::vec3 dVit = velocity[A] - velocity[B];
        glm::vec3 dPosNorm = glm::normalize(dPos);

        float diffLength = glm::length(dPos) - springs[gtid].restLength;
        partialForce[gtid] = (springs[gtid].stiffness * diffLength * dPosNorm) + (springs[gtid].damping * dPos * glm::dot(dVit, dPos));
    }
}

SolverExplicitGPU::SolverExplicitGPU(
        const glm::vec3 & gravity, 
        const glm::vec3 &wind,
        float viscosity,
        float deltaT): Solver(gravity, wind, viscosity, deltaT) {
            
    
}


void SolverExplicitGPU::setData(
        std::vector<Spring> * spring,
        std::vector<float> * vertex, 
        std::vector<Particle> * particles,
        std::vector<glm::vec3> * velocity, 
        std::vector<glm::vec3> * acceleration,
        std::vector<glm::vec3> * force, 
        std::vector<float> * mass) {
    
    this->springs = spring;
    this->vertex = vertex;
    this->particles = particles;
    this->velocity = velocity;
    this->acceleration = acceleration;
    this->force = force;
    this->mass = mass;

    
    
    this->partialForce = new std::vector<glm::vec3>(spring->size());


    int length = particles->size();

    cudaMalloc( (void**) &this->vertex_gpu, length * sizeof(float) * 8 );
    cudaMalloc( (void**) &this->velocity_gpu, length * sizeof(glm::vec3) );
    cudaMalloc( (void**) &this->partialForce_gpu, length * sizeof(glm::vec3) );
    cudaMalloc( (void**) &this->acceleration_gpu, length * sizeof(glm::vec3) );
    cudaMalloc( (void**) &this->force_gpu, length * sizeof(glm::vec3) );
    cudaMalloc( (void**) &this->mass_gpu, length * sizeof(float));
    cudaMalloc( (void**) &this->springs_gpu, spring->size() * sizeof(Spring) );
    cudaMalloc( (void**) &this->partialForce_gpu, spring->size() * sizeof(glm::vec3));
    cudaMalloc( (void**) &this->particles_gpu, length * sizeof(Particle));


    cudaMemcpy(mass_gpu, &(*mass)[0], length * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(velocity_gpu, &(*velocity)[0], length * sizeof(glm::vec3), cudaMemcpyHostToDevice);
    cudaMemcpy(vertex_gpu, &(*vertex)[0], length * sizeof(float) * 8, cudaMemcpyHostToDevice);
    cudaMemcpy(force_gpu, &(*force)[0], length * sizeof(glm::vec3), cudaMemcpyHostToDevice);
    cudaMemcpy(acceleration_gpu, &(*acceleration)[0], length * sizeof(glm::vec3), cudaMemcpyHostToDevice);
    cudaMemcpy(springs_gpu, &(*springs)[0], spring->size() * sizeof(Spring), cudaMemcpyHostToDevice);
    cudaMemcpy(particles_gpu, &(*particles)[0], length * sizeof(Particle), cudaMemcpyHostToDevice);
}


void SolverExplicitGPU::solve(int tps) {
    int length = particles->size();
    
    
    int blockSize = 1024;
    int gridSize = (int)ceil((float)length/blockSize);

    solveGPU<<<gridSize, blockSize>>>(vertex_gpu, particles_gpu, velocity_gpu, 
                            acceleration_gpu, force_gpu, partialForce_gpu, mass_gpu, gravity, wind, viscosity, deltaT, length);

    //cudaMemcpy(&(*vertex)[0], vertex_gpu, length * 8 * sizeof(float), cudaMemcpyDeviceToHost);
}

void SolverExplicitGPU::updateSprings() {
    int length = springs->size();
    int blockSize = 1024;
    int gridSize = (int)ceil((float)length/blockSize);

    updateSpringsGPU<<<gridSize, blockSize>>>(vertex_gpu, velocity_gpu, springs_gpu, partialForce_gpu, length);
}



void SolverExplicitGPU::update(int Tps){
    updateSprings();
    solve(Tps);
}

SolverExplicitGPU::~SolverExplicitGPU() {
    cudaFree(vertex_gpu);
    cudaFree(velocity_gpu);
    cudaFree(acceleration_gpu);
    cudaFree(force_gpu);
    cudaFree(mass_gpu);
    cudaFree(springs_gpu);
    cudaFree(particles_gpu);
    cudaFree(partialForce_gpu);
}