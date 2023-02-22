#include "Solver.h"

inline Solver::Solver(const std::vector<Spring*> &springs,
        const std::vector<glm::vec3> &position, 
        const std::vector<glm::vec3> &velocity, 
        const std::vector<glm::vec3> &acceleration,
        const std::vector<glm::vec3> &force, 
        const std::vector<float> &mass, 
        const glm::vec3 &gravity, 
        const glm::vec3 &wind,
        float timeStep, 
        float deltaT):
        springs(springs),
        position(position),
        velocity(velocity),
        acceleration(acceleration),
        force(force),
        mass(mass),
        gravity(gravity),
        wind(wind),
        timeStep(timeStep),
        deltaT(deltaT){


}

inline void Solver::updateSprings() {
    for (int i = 0; i < springs.size(); i++) {
        
    }
}

inline void Solver::update(){

    for(int i = 0; i < acceleration.size(); i++){
        if(mass[i] == 0.0f){
            acceleration[i] = glm::vec3(0.0f);
        }else{
            acceleration[i] = (force[i] / mass[i]) + gravity + wind;
        }       
    }
    
}