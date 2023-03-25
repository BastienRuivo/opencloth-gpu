#pragma once
#include "Solver.h"
#include <cuda.h>

class SolverExplicitGPUData : public SolverData
{
public:
    // CUDA BUFFERS
    glm::vec3 *velocity, *acceleration, 
                *force, *partialForce;
    Spring *springs;
    float *mass, *vertex;

    Particle *particles;

    int springCount, particleCount; 

    // CPU BUFFERS
    std::vector<float> *vertex_cpu;

    SolverExplicitGPUData(glm::vec3 gravity, glm::vec3 wind, float viscosity, float deltaT,
        std::vector<float> * vertex,
        std::vector<glm::vec3> * velocity,
        std::vector<glm::vec3> * acceleration,
        std::vector<glm::vec3> * force,
        std::vector<Particle> * particles,
        std::vector<Spring> * spring,
        std::vector<float> * mass);

    ~SolverExplicitGPUData();
};

class SolverExplicitGPU : public Solver
{
private : 
    SolverExplicitGPUData * _data;
public:
    SolverExplicitGPU(SolverExplicitGPUData * data);
    void update(int Tps);
    void updateSprings();
    void solve(int tps);
    ~SolverExplicitGPU();
};