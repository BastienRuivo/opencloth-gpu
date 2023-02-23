#ifndef MESH_H
#define MESH_H

#include <glad/glad.h>
#include <iostream>
#include <vector>
#include "Shader.h"
#include "Textures.h"


#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>

/** @class Mesh
 *  @brief Classe contenant les données d'un mesh servant à être référencée par un Object
 */
class Mesh
{
private:
    std::vector<float> m_vertex;  //!< Tableau des vertices à dessinner
    std::vector<uint>  m_indices; //!< Tableau des indices
    unsigned int m_VBO;           //!< Variable de référence du Vertex Buffer Object
    unsigned int m_EBO;           //!< Variable de référence de l'Element Buffer Object
    unsigned int m_VAO;           //!< Variable de référence du Vertex Array Object

    void init();    //!< initialise le mesh pour OpenGL
    void initVBO(); //!< initialise le VBO du mesh
    void initVAO(); //!< initialise le Vertex Array Attribue 
    void initEBO(); //!< initialise l'EBO du mesh

public:
    Mesh();
    ~Mesh();

    /** @brief Accesseur Vertex Array Object
     * @return uint représentant le VAO
    */
    uint getVAO() const;
    uint getVertexCount() const;
    uint getIndicesCount() const;

    std::vector<uint> getIndices() const;

    glm::vec3 getVertex(uint index) const;

    /** @brief remplit les vertices du mesh
     * @param vertices Vecteur contenant toutes les vertices
     * @param verticesOrder indices de l'ordre ou utiliser les vertices
     * @param uvs Vecteur contenant toutes les uv
     * @param colors Vecteur des couleurs utilisées
     * @param normals Vecteur des normales utilisées
     */
    Mesh& setPolygon(
        std::vector<glm::vec3> vertices,
        std::vector<uint> verticesOrder,
        std::vector<glm::vec3> normals = {},
        std::vector<glm::vec2> uvs = {}
    );
    static Mesh * initCube();
    static Mesh * initPlane(int divW, int divH);
    static Mesh * initTissus(int divW, int divH);

    Mesh& updateVertex(std::vector<glm::vec3> vertices);
};



#endif //MESH_H