
#ifndef SPRING_H
#define SPRING_H

#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>

#include <iostream>

#include "SpringInfo.h"

struct Spring
{
    // Identifiant
    uint id;

    // Particule A
    uint PA;

    // Particule B
    uint PB;

	// Longueur au repos
	float restLength;

    // Raideur
	float stiffness;

    // Amortissement
	float damping;
	
	// Facteur d amortissement
	float dampingFactor;
};
#endif