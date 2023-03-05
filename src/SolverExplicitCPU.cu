#include "SolverExplicitCPU.h"

SolverExplicitCPU::SolverExplicitCPU(
        const glm::vec3 & gravity, 
        const glm::vec3 &wind,
        float viscosity,
        float deltaT): Solver(gravity, wind, viscosity, deltaT) {
}

void SolverExplicitCPU::setData(
        std::vector<Spring> * spring,
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

    this->forcesToAdd.resize(springs->size());
}

void SolverExplicitCPU::updateSprings() {
    
    for(int i = 0; i < springs->size(); i++){
        int A = springs->at(i).PA;
        int B = springs->at(i).PB;

        glm::vec3 dPos = position->at(A) - position->at(B);
        glm::vec3 dVit = velocity->at(A) - velocity->at(B);
        glm::vec3 dPosNorm = glm::normalize(dPos);

        float diffLength = glm::length(dPos) - springs->at(i).restLength;

        glm::vec3 fRaideur = springs->at(i).stiffness * diffLength * dPosNorm;
        glm::vec3 fAmortissement = springs->at(i).damping * dPosNorm * glm::dot(dVit, dPosNorm);
        force->at(A) = force->at(A) - fRaideur - fAmortissement;
        force->at(B) = force->at(B) + fRaideur  + fAmortissement;
    }
}

void SolverExplicitCPU::solve(int Tps) {
    for(int i = 0; i < velocity->size(); i++)
    {
        if(mass->at(i) == 0.0f){
            acceleration->at(i) = glm::vec3(0.0f);
        }else{
            acceleration->at(i) = (force->at(i) / mass->at(i)) + gravity + wind;
        }
        force->at(i) = glm::vec3(0.0f);
        velocity->at(i) = velocity->at(i) + deltaT * (acceleration->at(i) - viscosity * velocity->at(i));
        position->at(i) = position->at(i) + deltaT * velocity->at(i);
    }
}

void SolverExplicitCPU::update(int Tps){
    updateSprings();
    solve(Tps);
}