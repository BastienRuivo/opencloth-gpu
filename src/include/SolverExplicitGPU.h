#pragma once
#include "Solver.h"
#include <cuda.h>

class SolverExplicitGPU : public Solver
{
private:
    /* data */
    glm::vec3 *position_gpu, *velocity_gpu, *acceleration_gpu, 
                *force_gpu;
    Spring *springs_gpu;
    float *mass_gpu;

    ForceToAdd *forcesToAdd_gpu;

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
        std::vector<glm::vec3> * position, 
        std::vector<glm::vec3> * velocity, 
        std::vector<glm::vec3> * acceleration,
        std::vector<glm::vec3> * force, 
        std::vector<float> * mass);

    void updateSprings();
    void solve(int tps);

    ~SolverExplicitGPU();

};