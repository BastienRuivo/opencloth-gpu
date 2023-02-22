#pragma once

#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>

 #include <vector>
 #include "Spring.h"

class Particle
{
private:
    int id;
    std::vector<Spring*> linkedSprings;
    glm::vec3 pos;
    float mass;

public:
    Particle(const Particle & p);
    Particle(int id, const glm::vec3 & pos, float mass);
    Particle();

    void addSpring(Spring* spring);
    void setId(int id);
    void setpos(const glm::vec3 & pos);
    void setMass(float mass);

    int getId() const;
    glm::vec3& getpos() const;
    float getMass() const;
    std::vector<Spring*> getLinkedSprings() const;

    int getNbNeighbours() const;

    ~Particle();
};