#include "Textures.h"
Textures::Textures()
{

}

void Textures::init()
{
    glEnable(GL_TEXTURE_2D);
    glEnable(GL_TEXTURE_3D);
}

void Textures::use2D(const std::string& key, uint texNumb)
{
    glActiveTexture(GL_TEXTURE0+texNumb);
    //std::cout<<"GL_TEXTURE"<<texNumb<<std::endl;
    glBindTexture(GL_TEXTURE_2D, m_texId[key]);
}

void Textures::Load2D(const std::string & key, const std::string & path)
{
    std::vector<unsigned char> data;
    uint width, height;


    //decode
    unsigned error = lodepng::decode(data, width, height, path.c_str());


    for(int i = 0; i < data.size(); i+=4)
    {
        std::reverse(data.begin()+i, data.begin()+i+4);
    }

    std::reverse(data.begin(), data.end());

    //if there's an error, display it
    if(error) std::cout << "decoder error " << error << ": " << lodepng_error_text(error) << std::endl;

    if(m_texId.find(key) == m_texId.end())
    {
        std::cout<<"Chargement de la texture : "<<key<<std::endl;
        m_texId.insert({key, 0});
        
    }
    else
    {
        std::cout<<"Rechargement de la texture : "<<key<<std::endl;
        uint texToDel[1] = {m_texId[key]};
        glDeleteTextures(1, texToDel);
    }

    glGenTextures(1, &m_texId[key]);
    glBindTexture(GL_TEXTURE_2D, m_texId[key]);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, &data[0]);
    glGenerateMipmap(GL_TEXTURE_2D);
}

glm::vec2 curlNoise2D(double x, double y, FastNoise & F)
{
    const float eps = 0.01;
    double n1 = F.GetNoise(x + eps, y);
    double n2 = F.GetNoise(x - eps, y);

    //Average to find approximate derivative
    double a = (n1 - n2)/(2 * eps);

    //Find rate of change in Y direction
    n1 = F.GetNoise(x, y + eps);
    n2 = F.GetNoise(x, y - eps);

    //Average to find approximate derivative
    double b = (n1 - n2)/(2 * eps);

    return glm::vec2(b, -a);
}

double myLerp(double x, double y, double ratio)
{
    return ratio * x + (1-ratio) * y;
}

const std::vector<std::string> explode(const std::string& s, const char& c)
{
	std::string buff{""};
	std::vector<std::string> v;

	for(auto n:s)
	{
		if(n != c) buff+=n; else
		if(n == c && buff != "") { v.push_back(buff); buff = ""; }
	}
	if(buff != "") v.push_back(buff);

	return v;
}

glm::vec3 curlNoise(glm::vec3 p, FastNoise & fast)
{
    const float e = 1;
    glm::vec3 dx = glm::vec3( e   , 0.0 , 0.0 );
    glm::vec3 dy = glm::vec3( 0.0 , e   , 0.0 );
    glm::vec3 dz = glm::vec3( 0.0 , 0.0 , e   );

    glm::vec3 pV0 = glm::vec3(  fast.GetNoise(p.x - e, p.y, p.z),
                                fast.GetNoise(p.x, p.y - e, p.z),
                                fast.GetNoise(p.x, p.y, p.z - e));

    glm::vec3 pV1 = glm::vec3(  fast.GetNoise(p.x + e, p.y, p.z),
                                fast.GetNoise(p.x, p.y + e, p.z),
                                fast.GetNoise(p.x, p.y, p.z + e));

    float x = pV1.z - pV0.z - pV1.y + pV0.y;
    float y = pV1.x - pV0.x - pV1.z + pV0.z;
    float z = pV1.y - pV0.y - pV1.x + pV0.x;

    const float divisor = 1.0 / ( 2.0 * e );
    return glm::normalize( glm::vec3( x , y , z ) * divisor );

}

Textures::~Textures()
{

}
