#include "Spring.h"

inline Spring::Spring() {
    PA = -1;
    PB = -1;
    param = nullptr;
    id = -1;
}

inline Spring::Spring(int p1, int p2, SpringInfo *info) {
    PA = p1;
    PB = p2;
    param = new SpringInfo(*info);
    id = -1;

    param->updateDampingFactor();
}

inline Spring::Spring(const Spring &s) {
    PA = s.PA;
    PB = s.PB;
    param = new SpringInfo(*s.param);
    id = s.id;
}

inline int Spring::getId() const {
    return id;
}

inline int Spring::getParticleA() const {
    return PA;
}

inline int Spring::getParticleB() const {
    return PB;
}

inline SpringInfo *Spring::getParam() const {
    return param;
}

inline void Spring::setId(int id) {
    this->id = id;
}

inline void Spring::setParticleA(int p) {
    PA = p;
}

inline void Spring::setParticleB(int p) {
    PB = p;
}

inline void Spring::setParam(SpringInfo *info) {
    param = new SpringInfo(*info);
}

inline Spring::~Spring() {
    PA = -1;
    PB = -1;
    delete param;
    id = -1;
}