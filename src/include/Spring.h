
#ifndef SPRING_H
#define SPRING_H

#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>

#include <iostream>

#include "SpringInfo.h"


class Spring
{
private:
    uint id;
    uint PA;
    uint PB;
    SpringInfo * param;

public:
    Spring();
    Spring(uint PA, uint PB, SpringInfo * param, double restLength);
    Spring(const Spring & s);

    void setId(uint id);
    void setParticleA(uint PA);
    void setParticleB(uint PB);
    void setParam(SpringInfo * param);

    uint getId() const; 
    uint getParticleA() const; 
    uint getParticleB() const; 
    SpringInfo * getParam() const;  

    ~Spring();
};

#endif