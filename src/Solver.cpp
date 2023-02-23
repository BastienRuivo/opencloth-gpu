#include "Solver.h"

Solver::Solver(
        const glm::vec3 &gravity, 
        const glm::vec3 &wind,
        float viscosity,
        float deltaT){
    
        this->gravity = gravity;
        this->wind = wind;
        this->viscosity = viscosity;
        this->deltaT = deltaT;

}

void Solver::setData(
        const std::vector<Spring*> &spring,
        const std::vector<glm::vec3> &position, 
        const std::vector<glm::vec3> &velocity, 
        const std::vector<glm::vec3> &acceleration,
        const std::vector<glm::vec3> &force, 
        const std::vector<float> &mass) {
    
    this->springs = spring;
    this->position = position;
    this->velocity = velocity;
    this->acceleration = acceleration;
    this->force = force;
    this->mass = mass;
}

void Solver::updateSprings() {
    for(int i = 0; i < springs.size(); i++){
        int A = springs[i]->getParticleA();
        int B = springs[i]->getParticleB();

        glm::vec3 dPos = position[A] - position[B];
        glm::vec3 dVit = velocity[A] - velocity[B];
        glm::vec3 dPosNorm = glm::normalize(dPos);

        float diffLength = glm::length(dPos) - springs[i]->getParam()->GetRestLength();

        glm::vec3 fRaideur = springs[i]->getParam()->GetStiffness() * diffLength * dPosNorm;
        glm::vec3 fAmortissement = springs[i]->getParam()->GetDamping() * dPosNorm * glm::dot(dVit, dPosNorm);

        force[A] = force[A] - fRaideur - fAmortissement;
        force[B] = force[B] + fRaideur  + fAmortissement;
    }
}

void Solver::updateAcceleration(){
    for(int i = 0; i < acceleration.size(); i++){
        if(mass[i] == 0.0f){
            acceleration[i] = glm::vec3(0.0f);
        }else{
            acceleration[i] = (force[i] / mass[i]) + gravity + wind;
        }       
    }
}

void Solver::resetForce(){
    for(int i = 0; i < force.size(); i++){
        force[i] = glm::vec3(0.0f);
    }
}

void Solver::solve(int Tps) {
    for(int i = 0; i < velocity.size(); i++)
    {
        velocity[i] = velocity[i] + deltaT * (acceleration[i] - viscosity * velocity[i]);
        position[i] = position[i] + deltaT * velocity[i];
    }
}

void Solver::update(int Tps){
    updateSprings();
    updateAcceleration();
    solve(Tps);
    resetForce();
}