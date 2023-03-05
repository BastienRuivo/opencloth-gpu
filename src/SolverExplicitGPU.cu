#include "SolverExplicitGPU.h"
#include <cuda.h>
#include <iostream>
#define GLM_COMPILER 0
// ====================================
// kernel declaration
// ====================================
__global__
void solveGPU(glm::vec3 *position,
                glm::vec3 *velocity,
                glm::vec3 *acceleration,
                glm::vec3 *force,
                float *mass,
                glm::vec3 gravity,
                glm::vec3 wind,
                float viscosity,
                float deltaT,
                int size) {

    int gtid = blockIdx.x*blockDim.x+threadIdx.x;
    if (gtid < size) {
        if(mass[gtid] == 0.0f){
            acceleration[gtid] = glm::vec3(0.0f);
        }else{
            acceleration[gtid] = (force[gtid] / mass[gtid]) + gravity + wind;
        }
        velocity[gtid] = velocity[gtid] + deltaT * (acceleration[gtid] - viscosity * velocity[gtid]);
        position[gtid] = position[gtid] + deltaT * velocity[gtid];
        force[gtid] = glm::vec3(0.0f);
    }
}


__global__ void updateTableInt(int * table, int size) {
    int gtid = threadIdx.x ;
    if (gtid < size) {
        table[gtid] = gtid;
    }
}

SolverExplicitGPU::SolverExplicitGPU(
        const glm::vec3 & gravity, 
        const glm::vec3 &wind,
        float viscosity,
        float deltaT): Solver(gravity, wind, viscosity, deltaT) {
            
    
}


void SolverExplicitGPU::setData(
        std::vector<Spring*> * spring,
        std::vector<glm::vec3> * position, 
        std::vector<glm::vec3> * velocity, 
        std::vector<glm::vec3> * acceleration,
        std::vector<glm::vec3> * force, 
        std::vector<float> * mass) {
    
    this->springs = spring;
    this->position = position;
    this->velocity = velocity;
    this->acceleration = acceleration;
    this->force = force;
    this->mass = mass;
    
    int length = position->size();

    cudaMalloc( (void**) &this->position_gpu, length * sizeof(glm::vec3) );
    cudaMalloc( (void**) &this->velocity_gpu, length * sizeof(glm::vec3) );
    cudaMalloc( (void**) &this->acceleration_gpu, length * sizeof(glm::vec3) );
    cudaMalloc( (void**) &this->force_gpu, length * sizeof(glm::vec3) );
    cudaMalloc( (void**) &this->mass_gpu, length * sizeof(float));
    cudaMalloc( (void**) &this->springs_gpu, spring->size() * sizeof(Spring) );


    cudaMemcpy(mass_gpu, &(*mass)[0], length * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(velocity_gpu, &(*velocity)[0], length * sizeof(glm::vec3), cudaMemcpyHostToDevice);
    cudaMemcpy(position_gpu, &(*position)[0], length * sizeof(glm::vec3), cudaMemcpyHostToDevice);
}


void SolverExplicitGPU::solve(int tps) {
    int length = position->size();
    cudaMemcpy(force_gpu, &(*force)[0], length * sizeof(glm::vec3), cudaMemcpyHostToDevice);
    cudaMemcpy(acceleration_gpu, &(*acceleration)[0], length * sizeof(glm::vec3), cudaMemcpyHostToDevice);
    
    int blockSize = 1024;
    int gridSize = (int)ceil((float)length/blockSize);

    solveGPU<<<gridSize, blockSize>>>(position_gpu, velocity_gpu, 
                            acceleration_gpu, force_gpu, mass_gpu, gravity, wind, viscosity, deltaT, this->position->size());


    cudaMemcpy(&(*force)[0], force_gpu, length * sizeof(glm::vec3), cudaMemcpyDeviceToHost);
    cudaMemcpy(&(*position)[0], position_gpu, length * sizeof(glm::vec3), cudaMemcpyDeviceToHost);
    cudaMemcpy(&(*acceleration)[0], acceleration_gpu, length * sizeof(glm::vec3), cudaMemcpyDeviceToHost);
    
}

void SolverExplicitGPU::updateSprings() {
    for(int i = 0; i < springs->size(); i++){
        int A = springs->at(i)->getParticleA();
        int B = springs->at(i)->getParticleB();

        glm::vec3 dPos = position->at(A) - position->at(B);
        glm::vec3 dVit = velocity->at(A) - velocity->at(B);
        glm::vec3 dPosNorm = glm::normalize(dPos);

        float diffLength = glm::length(dPos) - springs->at(i)->getParam()->GetRestLength();

        glm::vec3 fRaideur = springs->at(i)->getParam()->GetStiffness() * diffLength * dPosNorm;
        glm::vec3 fAmortissement = springs->at(i)->getParam()->GetDamping() * dPosNorm * glm::dot(dVit, dPosNorm);
        force->at(A) = force->at(A) - fRaideur - fAmortissement;
        force->at(B) = force->at(B) + fRaideur  + fAmortissement;
    }
}


void SolverExplicitGPU::update(int Tps){
    updateSprings();
    solve(Tps);
}