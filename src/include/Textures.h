#ifndef TEXTURES_H
#define TEXTURES_H
#include <string>
#include <iostream>
#include <stb/stb_image.h>
#include <lodepng/lodepng.h>
#include <vector>
#include <FastNoise/FastNoise.h>
#include <algorithm>
#include <map>

#include <fstream>

#include <glad/glad.h>
#include <cmath>

#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>

#include <iomanip>

//Typedef pour s'épargner les longs "unsigned char x = ..."
typedef unsigned char uchar;

/** @class Textures
 * @brief Contient toutes les textures du projet
 * */
class Textures
{
    public:

    /** @brief Constructeur par défaut */
    Textures();

    /** @brief Destructeur par défaut */
    ~Textures();

    /** @brief Initialise toutes les textures */
    void init();

    /** @brief Définit la texture a utiliser pour déssinner
     * @param texture uint contenant l'id de la texture
    */
    void use(const std::string& key, uint texNumb = 0);

    void load(const std::string & key, const std::string & path);
    
    std::map<std::string, uint> m_texId;
    private:
    
};


#endif // TEXTURE_H
