#ifndef SOLVER_H
#define SOLVER_H

#include <vector>

#include "Spring.h"

class Solver
{
protected:
    std::vector<Spring*> *springs;
    std::vector<glm::vec3> *position;
    std::vector<glm::vec3> *velocity;
    std::vector<glm::vec3> *acceleration;
    std::vector<glm::vec3> *force;
    std::vector<float> *mass;
    
    glm::vec3 gravity;
    glm::vec3 wind;

    float viscosity;

    float timeStep;
    float deltaT;

    virtual void updateSprings() = 0;
    virtual void updateAcceleration() = 0;
    virtual void solve(int tps) = 0;
    virtual void resetForce() = 0;

public:
    Solver(
        const glm::vec3 & gravity, 
        const glm::vec3 &wind,
        float viscosity,
        float deltaT);
    virtual void update(int Tps) = 0;
    virtual void setData(
        std::vector<Spring*> * spring,
        std::vector<glm::vec3> * position, 
        std::vector<glm::vec3> * velocity, 
        std::vector<glm::vec3> * acceleration,
        std::vector<glm::vec3> * force, 
        std::vector<float> * mass) = 0;
};

#endif