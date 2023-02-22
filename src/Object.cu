#include "Object.h"
#include <iostream>


Object::Object() :
is2D(false), has_face_culling(true), m_model(glm::mat4(1.f)), is_wireframe(false),
m_position({glm::vec3(0.f)}), m_shaderKey("basic2D"), m_rotation({glm::vec3(0.f)}), m_scale({glm::vec3(1.f)})
{

}

Object::~Object()
{
    
}

Object::Object(const Cube & cube) : Object(){
    m_mesh = Mesh::initCube();
    this->setPosition(cube.center)
        .setScale(glm::vec3(cube.width));
}

Object::Object(const Plane & plane) : Object(){
    m_mesh = Mesh::initPlane(plane.divW, plane.divH);
    this->setPosition(plane.center);
}

Object::Object(const Tissus & tissus) : Object(){
    m_mesh = Mesh::initTissus(tissus.divW, tissus.divH);
    this->setPosition(tissus.center);
}


Object& Object::rotate(float angle, glm::vec3 vAxis)
{
    m_model = glm::rotate(m_model, angle, vAxis);
    return *this;
}
Object& Object::scale(glm::vec3 vScale)
{
    m_model =  glm::scale(m_model, vScale);
    return *this;
}
Object& Object::translate(glm::vec3 vTranslate)
{
    m_model = glm::translate(m_model, vTranslate);
    return *this;
}

Object& Object::setFaceCulling(bool face_culling) {
    this->has_face_culling = face_culling;
    return *this;
}

bool Object::getFaceCulling() const { return has_face_culling; }

Object& Object::setShaderKey(const std::string & shaderKey)
{
    m_shaderKey = shaderKey;
    return *this;
}

std::string Object::getShaderKey() const
{
    return m_shaderKey;
}



Object& Object::resetModel()
{
    m_model = glm::mat4(1.f);
    return *this;
}

void Object::draw()
{
    glBindVertexArray(m_mesh->getVAO());
    glDrawElements(GL_TRIANGLES, this->m_mesh->getIndicesCount(), GL_UNSIGNED_INT, 0);
}



Object& Object::setTextureKeys(std::vector<std::string> keys)
{
    m_texturesKeys.insert(m_texturesKeys.end(), keys.begin(), keys.end());
    return *this;
}

Object& Object::setTextureTypeTo3D()
{
    is2D = false;
    return *this;
}
Object& Object::setTextureTypeTo2D()
{
    is2D = true;
    return *this;
}

void Object::setUniform(Shader & Shader, const glm::mat4 & view, const glm::mat4 & projection)
{
    Shader.use(m_shaderKey);
    Shader.setMat4(m_shaderKey, "view", view);
    Shader.setMat4(m_shaderKey, "projection", projection);
}

void Object::setUniforms(Shader & Shader, const glm::mat4 & model, const glm::mat4 & view, const glm::mat4 & projection)
{

}

void Object::render(Shader & Shader, Textures & textureManager, const glm::mat4 & view, const glm::mat4 & projection)
{
    this->setUniform(Shader, view, projection);
    // Si l'objet ne doit pas masquer l'environnement
    // activer puis désactiver le face culling
    if (!has_face_culling) {
        glDisable(GL_CULL_FACE);
    }
    GLint polygonMode;
    glGetIntegerv(GL_POLYGON_MODE, &polygonMode);
    if(is_wireframe) {
        glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
    }

    if(m_texturesKeys.size() == 0) {
        textureManager.use("default", 0);
    }
    for(int i = 0; i < m_texturesKeys.size(); i++)
    {
        textureManager.use(m_texturesKeys[i], i);
    }

    resetModel();
    translate(m_position);
    rotate(m_rotation.x, {1.f, 0.f, 0.f});
    rotate(m_rotation.y, {0.f, 1.f, 0.f});
    rotate(m_rotation.z, {0.f, 0.f, 1.f});
    scale(m_scale);
    Shader.setMat4(m_shaderKey, "model", m_model);
    setUniforms(Shader, m_model, view, projection);
    draw();

    if (!has_face_culling) { 
        glEnable(GL_CULL_FACE);
    }
    glPolygonMode(GL_FRONT_AND_BACK, polygonMode);
}

void Object::setMesh(Mesh * newMesh)
{
    m_mesh = newMesh;
}

Object& Object::setIsWireframe(bool wireframe)
{
    is_wireframe = wireframe;
    return *this;
}

bool Object::getIsWireframe() const
{
    return is_wireframe;
}


Object& Object::setPosition(glm::vec3 position)
{
    m_position = position;
    return *this;
}

Object& Object::setRotation(glm::vec3 rotation)
{
    m_rotation = rotation;
    return *this;
}

Object& Object::setScale(glm::vec3 scale)
{
    m_scale = scale;
    return *this;
}
