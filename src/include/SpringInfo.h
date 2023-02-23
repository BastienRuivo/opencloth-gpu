#ifndef SPRINGINFO_H
#define SPRINGINFO_H

class SpringInfo
{
private:
    // Raideur
	float stiffness;
	
	// Longueur au repos
	float restLength;
	
	// Facteur d amortissement
	float dampingFactor;

    // Amortissement
	float damping;

public:
    
    SpringInfo& operator=(const SpringInfo& springInfo);
    SpringInfo(const SpringInfo& springInfo);
    SpringInfo(float stiffness, float damping);
    SpringInfo();

    float GetStiffness() const;
    float GetRestLength() const;
    float GetDampingFactor() const;
    float GetDamping() const;

    void SetStiffness(float stiffness);
    void SetRestLength(float restLength);
    void SetDamping(float damping);
    
    void updateDampingFactor();
};

#endif