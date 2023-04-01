#include "World.h"
#include <GLFW/glfw3.h>
#include "SolverBuilder.h"
World::World(Textures &tex, Shader &shad): m_textures(tex), m_shader(shad)
{
    Tps = 0;
    std::cout<<"____Initialisation du monde____"<<std::endl;
    m_cam = new Camera();
    m_projection = glm::mat4(1.f);

    // Création du cube de test
    Object * defaultCube = new Object(Cube(glm::vec3(9.f, 0.f, 0.f), 1));
    defaultCube->setPosition(glm::vec3(10.f, 0.f, 0.f))
                .setShaderKey("basic2D")
                .setFaceCulling(true)
                .setTextureKeys({"sonc"});

    Object * defaultPlane = new Object(Plane(glm::vec3(0.f, -5.f, 0.f), 10, 10));
    defaultPlane->setPosition(glm::vec3(-5.f, 0.f, -5.f))
                .setIsWireframe(true)
                .setShaderKey("basic2D")
                .setFaceCulling(true);

    TissusObject * GPUCloth = new TissusObject(Tissus(1250, glm::vec3(0.f, 5.f, 0.f), 100, 100));
    SolverExplicitGPUData * solverGPUData = new SolverExplicitGPUData(glm::vec3(0, -9.8, 0), glm::vec3(0, 0, 0), 0.995, 0.001,
        GPUCloth->getVBO(),
        GPUCloth->getVelocity(),
        GPUCloth->getAcceleration(),
        GPUCloth->getForce(),
        GPUCloth->getParticles(),
        GPUCloth->getSprings(),
        GPUCloth->getMass()
    );

    GPUCloth->setSolver(SolverBuilder::create(solverGPUData))
                .setPosition(glm::vec3(0.f, 0.f, -5.f))
                .setShaderKey("basic2D")
                .setFaceCulling(true)
                .setTextureKeys({"kirbo"});

    addObject(GPUCloth);

    // TissusObject * CPUCloth = new TissusObject(Tissus(1250, glm::vec3(0.f, 5.f, 0.f), 400, 400));
    // SolverExplicitCPUData * solverCPUData = new SolverExplicitCPUData(glm::vec3(0, -9.8, 0), glm::vec3(2, 0, 0), 0.995, 0.00005,
    //     CPUCloth->getVertex(),
    //     CPUCloth->getVelocity(),
    //     CPUCloth->getAcceleration(),
    //     CPUCloth->getForce(),
    //     CPUCloth->getParticles(),
    //     CPUCloth->getSprings(),
    //     CPUCloth->getMass()
    // );

    // CPUCloth->setSolver(SolverBuilder::create(solverCPUData))
    //             .setPosition(glm::vec3(0.f, 0.f, -5.f))
    //             .setShaderKey("basic2D")
    //             .setFaceCulling(true)
    //             .setTextureKeys({"kirbo"});

    // addObject(CPUCloth);

    std::cout << "Ajout des objets au monde" << std::endl;
    addObject(defaultCube);
    addObject(defaultPlane);


    std::cout<<"Fin de l'initialisation du monde"<<std::endl;
}

void World::addObject(Object * obj)
{
    m_objects.push_back(obj);
}

void World::render(float ratioScreen)
{
    m_projection = glm::perspective(glm::radians(70.f), ratioScreen, 0.1f, 1000.f);

    m_cam->update();

    for(int i = 0; i < m_objects.size(); i++)
    {
        m_objects[i]->render(m_shader, m_textures, m_cam->getView(), m_projection);
    }
}

void World::update(float time)
{
    auto current_time = glfwGetTime();
    auto delta_time = current_time - m_time;
    m_time = current_time;
    if((int)Tps%60 == 0) {
        std::cout<<"FPS : "<<1.f/delta_time<<std::endl;
    }

  
  for(const auto & o : m_objects)
  {
      o->update(Tps);
  }

  Tps++;
}

Camera* World::getCam()
{
    return m_cam;
}

World::~World()
{
    m_cam->~Camera();
    delete m_cam;

    for(int i = 0; i < m_objects.size(); i++)
    {
        m_objects[i]->~Object();
        delete m_objects[i];
    }
}
