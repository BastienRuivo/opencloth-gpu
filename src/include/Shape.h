#pragma once
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>

class Cube {
    public:
    glm::vec3 center;
    int width;

    Cube(glm::vec3 center, int width) {
        this->center = center;
        this->width = width;
    }
};

class Plane {
    public:
    glm::vec3 center;
    int divW;
    int divH;

    Plane(glm::vec3 center, int divW, int divH) {
        this->center = center;
        this->divW = divW;
        this->divH = divH;
    }
};


class Tissus {
    public:
    glm::vec3 center;
    int divW;
    int divH;
    float mass;

    Tissus(float mass, glm::vec3 center, int divW, int divH) {
        this->mass = mass;
        this->center = center;
        this->divW = divW;
        this->divH = divH;
    }
};

