#include "Mesh.h"


Mesh::Mesh(/* args */)
{
    std::vector<float> m_vertex = {};  //!< Tableau des vertices à dessinner
    std::vector<uint>  m_indices = {}; //!< Tableau des indices
    unsigned int m_VBO = 0;           //!< Variable de référence du Vertex Buffer Object
    unsigned int m_EBO = 0;           //!< Variable de référence de l'Element Buffer Object
    unsigned int m_VAO = 0;           //!< Variable de référence du Vertex Array Object
}


Mesh::~Mesh()
{
    glDeleteVertexArrays(1, &m_VAO);
    glDeleteBuffers(1, &m_VBO);
    glDeleteBuffers(1, &m_EBO);
}

void Mesh::initVBO()
{
    // Permet de créer une zone mémoire dans la CG pour stocker le vertice;
    glGenBuffers(1, &m_VBO); // Genere l'ID du buffer
    glBindBuffer(GL_ARRAY_BUFFER, m_VBO); // Attribution de son type
    glBufferData(GL_ARRAY_BUFFER, sizeof(float) * m_vertex.size(), &m_vertex[0], GL_DYNAMIC_DRAW); // Lie les VAOdata auVAO m_VAO
}

void Mesh::initVAO()
{
    glGenVertexArrays(1, &m_VAO);
    glBindVertexArray(m_VAO);// Bind l'objet a la CG
    glBindBuffer(GL_ARRAY_BUFFER, m_VBO); // Lie le buffer de data aux attribues du m_VAO
    glBufferData(GL_ARRAY_BUFFER, sizeof(float) * m_vertex.size(), &m_vertex[0], GL_DYNAMIC_DRAW); // Lie les VAOdata auVAO m_VAO

    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, /*9*/ 8 * sizeof(float), (void*)0);
    glEnableVertexAttribArray(0);

    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, /*9*/ 8 * sizeof(float), (void*)(3 * sizeof(float)));
    glEnableVertexAttribArray(1);

    glVertexAttribPointer(2, 2/*3*/, GL_FLOAT, GL_FALSE, /*9*/ 8 * sizeof(float), (void*)(6 * sizeof(float)));
    glEnableVertexAttribArray(2);
}

void Mesh::initEBO()
{
    glGenBuffers(1, &m_EBO);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, m_EBO);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(uint) * m_indices.size(), &m_indices[0], GL_DYNAMIC_DRAW);
}

uint Mesh::getVAO() const
{
    return m_VAO;
}

uint Mesh::getVertexCount() const
{
    return m_vertex.size()/8;
}

uint Mesh::getIndicesCount() const
{
    return m_indices.size();
}

std::vector<uint> Mesh::getIndices() const
{
    return m_indices;
}

Mesh& Mesh::setPolygon(std::vector<glm::vec3> vertices, std::vector<uint> verticesOrder, std::vector<glm::vec3> normals, std::vector<glm::vec2> uvs)
{
    for(int i = 0; i < vertices.size(); i++) {

        m_vertex.push_back(vertices[i].x);
        m_vertex.push_back(vertices[i].y);
        m_vertex.push_back(vertices[i].z);

        m_vertex.push_back(normals[i].x);
        m_vertex.push_back(normals[i].y);
        m_vertex.push_back(normals[i].z);

        m_vertex.push_back(uvs[i].x);
        m_vertex.push_back(uvs[i].y);
    }
    m_indices = verticesOrder;
    init(); //sure?
    return *this;
}

glm::vec3 Mesh::getVertex(uint index) const
{
    return glm::vec3(m_vertex[index * 8], m_vertex[index * 8 + 1], m_vertex[index * 8 + 2]);
}

Mesh& Mesh::updateVertex(const std::vector<glm::vec3> & vertices)
{   

    #pragma omp parallel for
    for(int i = 0; i < vertices.size(); i++) {
        m_vertex[i * 8]     = vertices[i].x;
        m_vertex[i * 8 + 1] = vertices[i].y;
        m_vertex[i * 8 + 2] = vertices[i].z;
    }
    
    return updateBuffer();
}

Mesh& Mesh::updateBuffer()
{
    //Update the mesh in the GPU
    glBindBuffer(GL_ARRAY_BUFFER, m_VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(float) * m_vertex.size(), &m_vertex[0], GL_DYNAMIC_DRAW);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    return *this;
}



void Mesh::init()
{
    initVBO();
    initVAO();
    initEBO();
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindVertexArray(0);
    glEnable(GL_DEPTH_TEST);
}

uint Mesh::getVBO() const
{
    return m_VBO;
}

Mesh * Mesh::initCube()
{
    std::cout<<"Cube..."<<std::endl;
    Mesh * cube = new Mesh();
    /** Vertex Order Scheme
    *		   4 - 5
    *		  /   /|
    *		 0 - 1 7
    *		 |   |/
    *		 2 - 3
    */
    std::vector<glm::vec3> vertices =
    {
        glm::vec3(0.f, 1.f, 0.f),   // Top Left front 0
        glm::vec3(1.f, 1.f, 0.f),   // Top Right front 1
        glm::vec3(0.f, 0.f, 0.f),   // Bottom Left front 2
        glm::vec3(0.f, 0.f, 0.f),   // Bottom Left front 2
        glm::vec3(1.f, 1.f, 0.f),   // Top Right front 1
        glm::vec3(1.f, 0.f, 0.f),   // Bottom Right front 3

        glm::vec3(1.f, 1.f, 1.f),   // Top Right back 5
        glm::vec3(0.f, 1.f, 1.f),   // Top Left back 4
        glm::vec3(1.f, 0.f, 1.f),   // Bottom Right back 7
        glm::vec3(1.f, 0.f, 1.f),   // Bottom Right back 7
        glm::vec3(0.f, 1.f, 1.f),   // Top Left back 4
        glm::vec3(0.f, 0.f, 1.f),   // Bottom Left back 6

        glm::vec3(1.f, 1.f, 0.f),   // Top Right front 1
        glm::vec3(1.f, 1.f, 1.f),   // Top Right back 5
        glm::vec3(1.f, 0.f, 0.f),   // Bottom Right front 3
        glm::vec3(1.f, 0.f, 0.f),   // Bottom Right front 3
        glm::vec3(1.f, 1.f, 1.f),   // Top Right back 5
        glm::vec3(1.f, 0.f, 1.f),   // Bottom Right back 7

        glm::vec3(0.f, 1.f, 1.f),   // Top Left back 4
        glm::vec3(0.f, 1.f, 0.f),   // Top Left front 0
        glm::vec3(0.f, 0.f, 1.f),   // Bottom Left back 6
        glm::vec3(0.f, 0.f, 1.f),   // Bottom Left back 6
        glm::vec3(0.f, 1.f, 0.f),   // Top Left front 0
        glm::vec3(0.f, 0.f, 0.f),   // Bottom Left front 2

        glm::vec3(0.f, 1.f, 1.f),   // Top Left back 4
        glm::vec3(1.f, 1.f, 1.f),   // Top Right back 5
        glm::vec3(0.f, 1.f, 0.f),   // Top Left front 0
        glm::vec3(0.f, 1.f, 0.f),   // Top Left front 0
        glm::vec3(1.f, 1.f, 1.f),   // Top Right back 5
        glm::vec3(1.f, 1.f, 0.f),   // Top Right front 1

        glm::vec3(0.f, 0.f, 1.f),   // Bottom Left back 6
        glm::vec3(0.f, 0.f, 0.f),   // Bottom Left front 2
        glm::vec3(1.f, 0.f, 1.f),   // Bottom Right back 7
        glm::vec3(1.f, 0.f, 1.f),   // Bottom Right back 7
        glm::vec3(0.f, 0.f, 0.f),   // Bottom Left front 2
        glm::vec3(1.f, 0.f, 0.f)    // Bottom Right front 3
    };

    std::vector<uint> verticesOrder;

    for (uint i = 0; i < vertices.size(); i++)
    {
        verticesOrder.push_back(i);
    }

    std::vector<glm::vec3> normals = {

        // FRONT
        glm::vec3(-1.f, 0.f, 0.f), 
        glm::vec3(-1.f, 0.f, 0.f),
        glm::vec3(-1.f, 0.f, 0.f),
        glm::vec3(-1.f, 0.f, 0.f),
        glm::vec3(-1.f, 0.f, 0.f),
        glm::vec3(-1.f, 0.f, 0.f),

        // BACK NORMALS
        glm::vec3(1.f, 0.f, 0.f),
        glm::vec3(1.f, 0.f, 0.f),
        glm::vec3(1.f, 0.f, 0.f),
        glm::vec3(1.f, 0.f, 0.f),
        glm::vec3(1.f, 0.f, 0.f),
        glm::vec3(1.f, 0.f, 0.f),

        // RIGHT NORMALS
        glm::vec3(0.f, 0.f, 1.f),
        glm::vec3(0.f, 0.f, 1.f),
        glm::vec3(0.f, 0.f, 1.f),
        glm::vec3(0.f, 0.f, 1.f),
        glm::vec3(0.f, 0.f, 1.f),
        glm::vec3(0.f, 0.f, 1.f),

        // LEFT NORMALS
        glm::vec3(0.f, 0.f, -1.f),
        glm::vec3(0.f, 0.f, -1.f),
        glm::vec3(0.f, 0.f, -1.f),
        glm::vec3(0.f, 0.f, -1.f),
        glm::vec3(0.f, 0.f, -1.f),
        glm::vec3(0.f, 0.f, -1.f),

        // UPWARD NORMALS
        glm::vec3(0.f, 1.f, 0.f),
        glm::vec3(0.f, 1.f, 0.f),
        glm::vec3(0.f, 1.f, 0.f),
        glm::vec3(0.f, 1.f, 0.f),
        glm::vec3(0.f, 1.f, 0.f),
        glm::vec3(0.f, 1.f, 0.f),

        // DOWNWARD NORMALS
        glm::vec3(0.f, -1.f, 0.f),
        glm::vec3(0.f, -1.f, 0.f),
        glm::vec3(0.f, -1.f, 0.f),
        glm::vec3(0.f, -1.f, 0.f),
        glm::vec3(0.f, -1.f, 0.f),
        glm::vec3(0.f, -1.f, 0.f)
        
    };

    std::vector<glm::vec2> uv =
    {
        // Make the folowing triangle 1 2 0 0 2 3
        glm::vec2(0.f, 1.f), glm::vec2(1.f, 1.f), glm::vec2(0.f, 0.f),
        glm::vec2(0.f, 0.f), glm::vec2(1.f, 1.f), glm::vec2(1.f, 0.f),

        // Make the folowing triangle 1 2 0 0 2 3
        glm::vec2(0.f, 1.f), glm::vec2(1.f, 1.f), glm::vec2(0.f, 0.f),
        glm::vec2(0.f, 0.f), glm::vec2(1.f, 1.f), glm::vec2(1.f, 0.f),

        // Make the folowing triangle 1 2 0 0 2 3
        glm::vec2(0.f, 1.f), glm::vec2(1.f, 1.f), glm::vec2(0.f, 0.f),
        glm::vec2(0.f, 0.f), glm::vec2(1.f, 1.f), glm::vec2(1.f, 0.f),

        // Make the folowing triangle 1 2 0 0 2 3
        glm::vec2(0.f, 1.f), glm::vec2(1.f, 1.f), glm::vec2(0.f, 0.f),
        glm::vec2(0.f, 0.f), glm::vec2(1.f, 1.f), glm::vec2(1.f, 0.f),

        // Make the folowing triangle 3 0 2 2 0 1
        glm::vec2(1.f, 0.f), glm::vec2(0.f, 0.f), glm::vec2(1.f, 1.f),
        glm::vec2(1.f, 1.f), glm::vec2(0.f, 0.f), glm::vec2(0.f, 1.f),

        // Make the folowing triangle 0 1 3 3 1 2
        glm::vec2(0.f, 0.f), glm::vec2(0.f, 1.f), glm::vec2(1.f, 0.f),
        glm::vec2(1.f, 0.f), glm::vec2(0.f, 1.f), glm::vec2(1.f, 1.f)
    };
    
    cube->setPolygon(vertices, verticesOrder, normals, uv);
    return cube;
}

Mesh * Mesh::initPlane(int divW, int divH) {
    std::cout<<"Plane..."<<std::endl;
    Mesh * plane = new Mesh();
    std::vector<glm::vec3> vertices;
    std::vector<glm::vec3> normals;
    std::vector<glm::vec2> uvs;
    std::vector<unsigned int> verticesOrder;

    for (int j = 0; j < divH; j++) {
        for (int i = 0; i < divW; i++) {
            vertices.push_back(glm::vec3(i, 0, j));
            if(i < divW - 1 && j < divH - 1) {
                verticesOrder.push_back(i * divH + j);
                verticesOrder.push_back((i + 1) * divH + j);
                verticesOrder.push_back(i * divH + (j + 1));
                verticesOrder.push_back(i * divH + (j + 1));
                verticesOrder.push_back((i + 1) * divH + j);
                verticesOrder.push_back((i + 1) * divH + (j + 1));
            }
            normals.push_back(glm::vec3(0, 1, 0));
            uvs.push_back(glm::vec2(i/(float)divW, j/float(divH)));
        }
    }

    plane->setPolygon(vertices, verticesOrder, normals, uvs);
    return plane;
}

Mesh * Mesh::initTissus(int divW, int divH) {
    std::cout<<"Tissus..."<<std::endl;
    Mesh * tissus = new Mesh();
    std::vector<glm::vec3> vertices;
    std::vector<glm::vec3> normals;
    std::vector<glm::vec2> uvs;
    std::vector<unsigned int> verticesOrder;

    for (int j = 0; j < divH; j++) {
        for (int i = 0; i < divW; i++) {
            vertices.push_back(glm::vec3(i/(float)divW, j/(float)divH, 0));
            if(i < divW - 1 && j < divH - 1) {
                verticesOrder.push_back(i * divH + j);
                verticesOrder.push_back(i * divH + j + 1);
                verticesOrder.push_back((i + 1) * divH + j);
                
                verticesOrder.push_back((i + 1) * divH + j);
                verticesOrder.push_back(i * divH + j + 1);
                verticesOrder.push_back((i + 1) * divH + j + 1);
            }
            normals.push_back(glm::vec3(0, 0, 1));
            uvs.push_back(glm::vec2(i/(float)divW, j/(float)divH));
        }
    }

    tissus->setPolygon(vertices, verticesOrder, normals, uvs);
    return tissus;
}