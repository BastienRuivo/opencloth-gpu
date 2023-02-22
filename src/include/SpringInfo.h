#pragma once

class SpringInfo
{
private:
    // Raideur
	float stiffness;;    
	
	// Longueur au repos
	float restLength;
	
	// Facteur d amortissement
	float dampingFactor;

    // Amortissement
	float damping;

public:
    
    inline SpringInfo& operator=(const SpringInfo& springInfo);
    inline SpringInfo(const SpringInfo& springInfo);
    inline SpringInfo(float stiffness, float restLength, float dampingFactor);
    inline SpringInfo();

    inline float GetStiffness() const;
    inline float GetRestLength() const;
    inline float GetDampingFactor() const;
    inline float GetDamping() const;

    inline void SetStiffness(float stiffness);
    inline void SetRestLength(float restLength);
    inline void SetDamping(float damping);
    
    inline void updateDampingFactor();
};