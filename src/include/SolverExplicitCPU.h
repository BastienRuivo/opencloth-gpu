#pragma once


#include <vector>
#include "Solver.h"

class SolverExplicitCPUData : public SolverData
{
public:
    std::vector<float> *vertex;
    std::vector<glm::vec3> * velocity;
    std::vector<glm::vec3> * acceleration;
    std::vector<glm::vec3> * force;
    std::vector<float> * mass;

    std::vector<Spring> *springs;
    std::vector<glm::vec3> *partialForce;
    std::vector<Particle> *particles;


    SolverExplicitCPUData(glm::vec3 gravity, glm::vec3 wind, float viscosity, float deltaT,
        std::vector<float> * vertex,
        std::vector<glm::vec3> * velocity,
        std::vector<glm::vec3> * acceleration,
        std::vector<glm::vec3> * force,
        std::vector<Particle> * particles,
        std::vector<Spring> * spring,
        std::vector<float> * mass);

    ~SolverExplicitCPUData();
    
};

class SolverExplicitCPU : public Solver
{
private:
    SolverExplicitCPUData * _data;
public:
    SolverExplicitCPU(SolverExplicitCPUData * data);
    void update(int Tps);
    void updateSprings();
    void solve(int tps);
    ~SolverExplicitCPU();
};