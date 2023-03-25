#pragma once

#include "Solver.h"
#include "SolverExplicitCPU.h"
#include "SolverExplicitGPU.h"


class SolverBuilder
{
    public :
    static Solver* create(SolverExplicitCPUData * data) { return new SolverExplicitCPU(data); }
    static Solver* create(SolverExplicitGPUData * data) { return new SolverExplicitGPU(data); }
};
