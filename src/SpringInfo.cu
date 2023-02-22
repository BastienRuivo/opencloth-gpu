#include "SpringInfo.h"


inline void SpringInfo::updateDampingFactor()
{
    stiffness != 0 ? dampingFactor = damping / stiffness : dampingFactor = 1000.f;
}

inline SpringInfo & SpringInfo::operator=(const SpringInfo& s)
{
    stiffness = s.stiffness;
    damping = s.damping;
    restLength = s.restLength;
    return *this;
}

inline SpringInfo::SpringInfo(const SpringInfo& s)
{
    stiffness = s.stiffness;
    damping = s.damping;
    restLength = s.restLength;
}


inline SpringInfo::SpringInfo(float stiffness, float damping, float restLength)
{
    this->stiffness = stiffness;
    this->damping = damping;
    this->restLength = restLength;
}

inline SpringInfo::SpringInfo()
{
    stiffness = 0;
    damping = 0;
    restLength = 0;
}

inline SpringInfo::~SpringInfo()
{
}

inline void SpringInfo::SetStiffness(float stiffness)
{
    this->stiffness = stiffness;
}

inline void SpringInfo::SetDamping(float damping)
{
    this->damping = damping;
}

inline void SpringInfo::SetRestLength(float restLength)
{
    this->restLength = restLength;
}

inline float SpringInfo::GetStiffness() const
{
    return stiffness;
}

inline float SpringInfo::GetDamping() const
{
    return damping;
}

inline float SpringInfo::GetRestLength() const
{
    return restLength;
}

inline float SpringInfo::GetDampingFactor() const
{
    return dampingFactor;
}