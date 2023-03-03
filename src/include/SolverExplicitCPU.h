#pragma once

#include "Solver.h"

class SolverExplicitCPU : public Solver
{
private:
    /* data */
public:
    SolverExplicitCPU(
        const glm::vec3 & gravity, 
        const glm::vec3 &wind,
        float viscosity,
        float deltaT);

    void update(int Tps);
    void setData(
        std::vector<Spring*> * spring,
        std::vector<glm::vec3> * position, 
        std::vector<glm::vec3> * velocity, 
        std::vector<glm::vec3> * acceleration,
        std::vector<glm::vec3> * force, 
        std::vector<float> * mass);

    void updateSprings();
    void updateAcceleration();
    void solve(int tps);
    void resetForce();

};