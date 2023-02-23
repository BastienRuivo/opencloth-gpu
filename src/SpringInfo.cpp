#include "SpringInfo.h"


void SpringInfo::updateDampingFactor()
{
    if(stiffness == 0)
        dampingFactor = 1000.f;
    else
        dampingFactor = damping / stiffness;
}

SpringInfo & SpringInfo::operator=(const SpringInfo& s)
{
    stiffness = s.stiffness;
    damping = s.damping;
    restLength = s.restLength;
    return *this;
}

SpringInfo::SpringInfo(const SpringInfo &s)
{
    stiffness = s.stiffness;
    damping = s.damping;
    restLength = s.restLength;
}


SpringInfo::SpringInfo(float stiffness, float damping)
{
    this->stiffness = stiffness;
    this->damping = damping;
}

SpringInfo::SpringInfo()
{
    stiffness = 0;
    damping = 0;
    restLength = 0;
}


void SpringInfo::SetStiffness(float stiffness)
{
    this->stiffness = stiffness;
}

void SpringInfo::SetDamping(float damping)
{
    this->damping = damping;
}

void SpringInfo::SetRestLength(float restLength)
{
    this->restLength = restLength;
}

float SpringInfo::GetStiffness() const
{
    return stiffness;
}

float SpringInfo::GetDamping() const
{
    return damping;
}

float SpringInfo::GetRestLength() const
{
    return restLength;
}

float SpringInfo::GetDampingFactor() const
{
    return dampingFactor;
}