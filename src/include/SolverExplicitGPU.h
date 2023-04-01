#pragma once
#include "Solver.h"
#include <cuda.h>
#include <cuda_gl_interop.h>
#include "cuda_helper_math.h"

class SolverExplicitGPUData : public SolverData
{
public:
    // CUDA BUFFERS
    float3 *velocity, *acceleration, 
                *force, *partialForce;
    Spring *springs;
    float *mass, * vertex;

    float3 gravity_gpu, wind_gpu;

    Particle *particles;

    int springCount, particleCount; 

    // GL BUFFERS
    uint VBO;
    cudaGraphicsResource *cudaVboResource;
    size_t vertexSize;

    // CPU BUFFERS
    std::vector<float> *vertex_cpu;

    // Cuda current stream
    SolverExplicitGPUData(glm::vec3 gravity, glm::vec3 wind, float viscosity, float deltaT,
        uint VBO,
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