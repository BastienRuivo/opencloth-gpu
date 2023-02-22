#include "Particle.h"

inline Particle::Particle() {
    id = -1;
}

inline Particle::Particle(int id, const glm::vec3 & pos, float mass) : id(id), pos(pos), mass(mass) {
}

inline Particle::Particle(const Particle & p) : id(p.getId()), pos(), mass(p.mass) {
    auto springs = p.getLinkedSprings();
    for(const auto & spring : springs) {
        this->addSpring(spring);
    }
}