#ifndef SOLVER_H
#define SOLVER_H

#include <vector>

#include "Spring.h"

class Solver
{
private:
    std::vector<Spring*> springs;
    std::vector<glm::vec3> position;
    std::vector<glm::vec3> velocity;
    std::vector<glm::vec3> acceleration;
    std::vector<glm::vec3> force;
    std::vector<float> mass;
    
    glm::vec3 gravity;
    glm::vec3 wind;

    float viscosity;

    float timeStep;
    float deltaT;

    void updateSprings();
    void updateAcceleration();
    void solve(int tps);
    void resetForce();

public:
    Solver(
        const glm::vec3 &gravity, 
        const glm::vec3 &wind,
        float viscosity,
        float deltaT);
    void update(int Tps);
    void setData(
        const std::vector<Spring*> &spring,
        const std::vector<glm::vec3> &position, 
        const std::vector<glm::vec3> &velocity, 
        const std::vector<glm::vec3> &acceleration,
        const std::vector<glm::vec3> &force, 
        const std::vector<float> &mass);
};

#endif