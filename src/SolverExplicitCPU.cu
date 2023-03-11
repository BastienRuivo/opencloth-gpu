#include "SolverExplicitCPU.h"
#include <omp.h>

SolverExplicitCPU::SolverExplicitCPU(
        const glm::vec3 & gravity, 
        const glm::vec3 &wind,
        float viscosity,
        float deltaT): Solver(gravity, wind, viscosity, deltaT) {
}

void SolverExplicitCPU::setData(
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

    this->partialForce = new std::vector<glm::vec3>(springs->size());
}

void SolverExplicitCPU::updateSprings() {
    #pragma omp parallel for
    for(int i = 0; i < springs->size(); i++){
        int A = springs->at(i).PA;
        int B = springs->at(i).PB;

        glm::vec3 dPos;
        dPos.x = vertex->at(A * 8) - vertex->at(B * 8);
        dPos.y = vertex->at(A * 8 + 1) - vertex->at(B * 8 + 1);
        dPos.z = vertex->at(A * 8 + 2) - vertex->at(B * 8 + 2);

        glm::vec3 dVit = velocity->at(A) - velocity->at(B);
        glm::vec3 dPosNorm = glm::normalize(dPos);

        float diffLength = glm::length(dPos) - springs->at(i).restLength;

        glm::vec3 f = (springs->at(i).stiffness * diffLength * dPosNorm) + (springs->at(i).damping * dPosNorm * glm::dot(dVit, dPosNorm));
        
        partialForce->at(i) = f;
    }
}

void SolverExplicitCPU::solve(int Tps) {
    #pragma omp parallel for
    for(int i = 0; i < velocity->size(); i++)
    {
        for(int j = 0; j < particles->at(i).nbSpring; j++){
            int springIndex = particles->at(i).springs[j];
            if(particles->at(i).isNegative[j]) {
                force->at(i) -= partialForce->at(springIndex);
            } else {
                force->at(i) += partialForce->at(springIndex);
            }
        }
        if(mass->at(i) == 0.0f){
            acceleration->at(i) = glm::vec3(0.0f);
        }else{
            acceleration->at(i) = (force->at(i) / mass->at(i)) + gravity + wind;
        }
        force->at(i) = glm::vec3(0.0f);
        velocity->at(i) = velocity->at(i) + deltaT * (acceleration->at(i) - viscosity * velocity->at(i));
        vertex->at(i) = vertex->at(i * 8) + deltaT * velocity->at(i).x;
        vertex->at(i * 8 + 1) = vertex->at(i * 8 + 1) + deltaT * velocity->at(i).y;
        vertex->at(i * 8 + 2) = vertex->at(i * 8 + 2) + deltaT * velocity->at(i).z;
    }
}

void SolverExplicitCPU::update(int Tps){
    updateSprings();
    solve(Tps);
}