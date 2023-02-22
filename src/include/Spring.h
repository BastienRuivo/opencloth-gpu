#pragma once

#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>

#include <iostream>

#include "SpringInfo.h"
#include "Particle.h"


class Spring
{
private:
    int id;
    int PA;
    int PB;
    SpringInfo * param;

public:
    Spring();
    Spring(int PA, int PB, SpringInfo * param);
    Spring(const Spring & s);

    void setId(int id);
    void setParticleA(int PA);
    void setParticleB(int PB);
    void setParam(SpringInfo * param);

    glm::vec3 getForce();

    int getId() const;
    int getParticleA() const;
    int getParticleB() const;
    SpringInfo * getParam() const;
};
