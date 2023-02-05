#ifndef OBJECTS_H
#define OBJECTS_H

#include "Object.h"

#include <iostream>


/** @class Cube
 * @brief Représente un cube
 */
class Cube : public Object
{
public:
    /** @brief Constructeur de Cube
     * @param position la position du cube
     */
    Cube(glm::vec3 position) : Object()
    {
        setPosition(position);
        setFaceCulling(true);
        setTextureTypeTo2D();
        this->setMesh(Mesh::initCube());
    }
    ~Cube() {}

protected:
    void setUniforms(
        Shader& shaders,
        const glm::mat4 &model,
        const glm::mat4 &view,
        const glm::mat4 &projection
    ) override {
        return;
    }

};


#endif //OBJECTS_H
