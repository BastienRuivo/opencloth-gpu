#include "SolverExplicitCPU.h"
#include <omp.h>

SolverExplicitCPUData::SolverExplicitCPUData(glm::vec3 gravity, glm::vec3 wind, float viscosity, float deltaT,
        std::vector<float> * vertex,
        std::vector<glm::vec3> * velocity,
        std::vector<glm::vec3> * acceleration,
        std::vector<glm::vec3> * force,
        std::vector<Particle> * particles,
        std::vector<Spring> * spring,
        std::vector<float> * mass) : SolverData(gravity, wind, viscosity, deltaT) {
    this->vertex = vertex;
    this->velocity = velocity;
    this->acceleration = acceleration;
    this->force = force;
    this->mass = mass;
    this->particles = particles;
    this->springs = spring;

    this->partialForce = new std::vector<glm::vec3>(springs->size());
}

SolverExplicitCPU::SolverExplicitCPU(SolverExplicitCPUData * data) : _data(data) {
    _data = data;
}

void SolverExplicitCPU::updateSprings() {
    #pragma omp parallel for
    for(int i = 0; i < _data->springs->size(); i++){
        int A = _data->springs->at(i).PA;
        int B = _data->springs->at(i).PB;

        glm::vec3 dPos;
        dPos.x = _data->vertex->at(A * 8) - _data->vertex->at(B * 8);
        dPos.y = _data->vertex->at(A * 8 + 1) - _data->vertex->at(B * 8 + 1);
        dPos.z = _data->vertex->at(A * 8 + 2) - _data->vertex->at(B * 8 + 2);

        glm::vec3 dVit = _data->velocity->at(A) - _data->velocity->at(B);
        glm::vec3 dPosNorm = glm::normalize(dPos);

        float diffLength = glm::length(dPos) - _data->springs->at(i).restLength;

        _data->partialForce->at(i) = (_data->springs->at(i).stiffness * diffLength * dPosNorm) + (_data->springs->at(i).damping * dPosNorm * glm::dot(dVit, dPosNorm));
    }
}

void SolverExplicitCPU::solve(int Tps) {
    #pragma omp parallel for
    for(int i = 0; i < _data->velocity->size(); i++)
    {
        for(int j = 0; j < _data->particles->at(i).nbSpring; j++){
            int springIndex = _data->particles->at(i).springs[j];
            if(_data->particles->at(i).isNegative[j]) {
                _data->force->at(i) -= _data->partialForce->at(springIndex);
            } else {
                _data->force->at(i) += _data->partialForce->at(springIndex);
            }
        }
        if(_data->mass->at(i) == 0.0f){
            _data->acceleration->at(i) = glm::vec3(0.0f);
        }else{
            _data->acceleration->at(i) = (_data->force->at(i) / _data->mass->at(i)) + _data->gravity + _data->wind;
        }
        _data->force->at(i) = glm::vec3(0.0f);
        _data->velocity->at(i) = _data->velocity->at(i) + _data->deltaT * (_data->acceleration->at(i) - _data->viscosity * _data->velocity->at(i));
        _data->vertex->at(i) = _data->vertex->at(i * 8) + _data->deltaT * _data->velocity->at(i).x;
        _data->vertex->at(i * 8 + 1) = _data->vertex->at(i * 8 + 1) + _data->deltaT * _data->velocity->at(i).y;
        _data->vertex->at(i * 8 + 2) = _data->vertex->at(i * 8 + 2) + _data->deltaT * _data->velocity->at(i).z;
    }
}

void SolverExplicitCPU::update(int Tps){
    updateSprings();
    solve(Tps);
}

SolverExplicitCPU::~SolverExplicitCPU() {
    delete _data->partialForce;
}