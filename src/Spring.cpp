#include "Spring.h"

Spring::Spring() {
    PA = -1;
    PB = -1;
    param = nullptr;
    id = -1;
}

Spring::Spring(uint p1, uint p2, SpringInfo *info, double restLength) {
    PA = p1;
    PB = p2;
    param = new SpringInfo(*info);
    id = -1;

    param->SetRestLength(restLength);
    param->updateDampingFactor();
}

Spring::Spring(const Spring &s) {
    PA = s.PA;
    PB = s.PB;
    param = new SpringInfo(*s.param);
    id = s.id;
}

uint Spring::getId() const {
    return id;
}

uint Spring::getParticleA() const {
    return PA;
}

uint Spring::getParticleB() const {
    return PB;
}

SpringInfo *Spring::getParam() const {
    return param;
}

void Spring::setId(uint id) {
    this->id = id;
}

void Spring::setParticleA(uint p) {
    PA = p;
}

void Spring::setParticleB(uint p) {
    PB = p;
}

void Spring::setParam(SpringInfo *info) {
    param = new SpringInfo(*info);
}

Spring::~Spring() {
    PA = -1;
    PB = -1;
    delete param;
    id = -1;
}