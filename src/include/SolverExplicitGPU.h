#pragma once
#include "Solver.h"
#include <cuda.h>

class SolverExplicitGPU : public Solver
{
private:
    /* data */
    glm::vec3 *velocity_gpu, *acceleration_gpu, 
                *force_gpu, *partialForce_gpu;
    Spring *springs_gpu;
    float *mass_gpu, *vertex_gpu;

    Particle *particles_gpu;

    // float *viscosity_gpu = new float[ length ];
    // float *deltaT_gpu = new float[ length ];
public:
    SolverExplicitGPU(
        const glm::vec3 & gravity, 
        const glm::vec3 &wind,
        float viscosity,
        float deltaT);

    void update(int Tps);
    void setData(
        std::vector<Spring> * spring,
        std::vector<float> * vertex, 
        std::vector<Particle> * particles,
        std::vector<glm::vec3> * velocity, 
        std::vector<glm::vec3> * acceleration,
        std::vector<glm::vec3> * force, 
        std::vector<float> * mass);

    void updateSprings();
    void solve(int tps);

    ~SolverExplicitGPU();

};