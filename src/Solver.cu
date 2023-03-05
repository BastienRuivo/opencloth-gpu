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



void printVec(glm::vec3 vec){
    std::cout<<"{ x : " << vec.x<<", y : "<<vec.y<<", z: "<<vec.z<<"}"<<std::endl;
}
