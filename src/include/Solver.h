#ifndef SOLVER_H
#define SOLVER_H

#include <vector>

#include "Spring.h"

const int MAX_SPRING = 8;

struct Particle {
    int springs[MAX_SPRING];
    bool isNegative[MAX_SPRING];
    int nbSpring = 0;
};

class Solver
{
protected:
    std::vector<Spring> *springs;
    std::vector<float> *vertex;
    std::vector<glm::vec3> *velocity;
    std::vector<glm::vec3> *acceleration;
    std::vector<glm::vec3> *force;
    std::vector<glm::vec3> *partialForce;
    std::vector<float> *mass;
    std::vector<Particle> *particles;
    
    glm::vec3 gravity;
    glm::vec3 wind;

    float viscosity;

    float timeStep;
    float deltaT;

    virtual void updateSprings() = 0;
    virtual void solve(int tps) = 0;

public:
    Solver(
        const glm::vec3 & gravity, 
        const glm::vec3 &wind,
        float viscosity,
        float deltaT);
    virtual void update(int Tps) = 0;
    virtual void setData(
        std::vector<Spring> * spring,
        std::vector<float> * vertex, 
        std::vector<Particle> * particles,
        std::vector<glm::vec3> * velocity, 
        std::vector<glm::vec3> * acceleration,
        std::vector<glm::vec3> * force, 
        std::vector<float> * mass) = 0;
};

#endif