#pragma once
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>

class Cube {
    glm::vec3 center;
    int width;

    Cube(glm::vec3 center, int width) {
        this->center = center;
        this->width = width;
    }
};