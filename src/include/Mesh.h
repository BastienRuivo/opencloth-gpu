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

    /** @brief remplit les vertices du mesh
     * @param vertices Vecteur contenant toutes les vertices
     * @param verticesOrder indices de l'ordre ou utiliser les vertices
     * @param uvArray Vecteur contenant toutes les uv
     * @param uvIndex Vecteur contenant les indices de l'odre ou utiliser les uvs
     * @param color Vecteur des couleurs utilisées
     * @param colorOrder Vecteur contenant les indices des couleurs (de color) a utiliser dans l'ordre
     */
    Mesh& setPolygon(
        std::vector<float> vertices,
        std::vector<uint> verticesOrder,
        std::vector<float> uvArray = {},
        std::vector<uint> uvIndex = {},
        std::vector<float> color = {},
        std::vector<uint> colorOrder = {}
    );
    static Mesh * initCube()
    {
        std::cout<<"Cube...";
        /** Vertex Order Scheme
        *		   4 - 5
        *		  /   /|
        *		 0 - 1 7
        *		 |   |/
        *		 2 - 3
        */
        std::vector<float> vertices =
        {
            0.f, 1.f, 0.f,   // Top Left front 0
            1.f, 1.f, 0.f,   // Top Right front 1
            0.f, 0.f, 0.f,   // Bottom Left front 2
            1.f, 0.f, 0.f,   // Bottom Right front 3

            0.f, 1.f, 1.f,   // Top Left back 4
            1.f, 1.f, 1.f,   // Top Right back 5
            0.f, 0.f, 1.f,   // Bottom Left back 6
            1.f, 0.f, 1.f    // Bottom Right back 7
        };

        std::vector<uint> verticesOrder =
        {
            // AVANT ARRIERE
            0, 1, 2,
            2, 1, 3,

            5, 4, 7,
            7, 4, 6,

            // DROITE GAUCHE
            1, 5, 3,
            3, 5, 7,

            4, 0, 6,
            6, 0, 2,

            // HAUT BAS
            4, 5, 0,
            0, 5, 1,

            6, 2, 7,
            7, 2, 3
        };

        std::vector<float> uv =
        {
            0.f, 0.f,
            0.f, 1.f,
            1.f, 1.f,
            1.f, 0.f
        };

        std::vector<uint> uvIndex
        {
            1, 2, 0,
            0, 2, 3,

            1, 2, 0,
            0, 2, 3,

            1, 2, 0,
            0, 2, 3,

            1, 2, 0,
            0, 2, 3,

            3, 0, 2,
            2, 0, 1,

            0, 1, 3,
            3, 1, 2
        };
        Mesh * cube = new Mesh();
        cube->setPolygon(vertices, verticesOrder, uv, uvIndex/*, color, colorId*/);
        return cube;
    }
};

#endif //MESH_H