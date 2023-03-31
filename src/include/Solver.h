#ifndef SOLVER_H
#define SOLVER_H

#include <vector>

#include "Spring.h"

const int MAX_SPRING = 8;

enum SolverType {
    SOLVER_CPU,
    SOLVER_GPU
};

struct Particle {
    int springs[MAX_SPRING];
    bool isNegative[MAX_SPRING];
    int nbSpring = 0;
};

class SolverData
{
    public :
    glm::vec3 gravity;
    glm::vec3 wind;
    float viscosity;
    float deltaT;

    SolverData(glm::vec3 gravity, glm::vec3 wind, float viscosity, float deltaT) {
        this->gravity = gravity;
        this->wind = wind;
        this->viscosity = viscosity;
        this->deltaT = deltaT;
    }

    ~SolverData() {}
};

class Solver
{
protected:
    SolverType type;
    virtual void updateSprings() = 0;
    virtual void solve(int tps) = 0;
    ~Solver() {};

public:
    virtual void update(int Tps) = 0;
    void printVec(glm::vec3 vec){
        std::cout<<"{ x : " << vec.x<<", y : "<<vec.y<<", z: "<<vec.z<<"}"<<std::endl;
    }
    SolverType getType() const { return type; }
};

#endif