#ifndef TISSUSOBJECT_H
#define TISSUSOBJECT_H


#include "Object.h"
#include "Solver.h"

class TissusObject : public Object 
{
  public:
  TissusObject(const Tissus & t);
  TissusObject& setSolver(Solver * solver);
  void update(int Tps);
  void updateMesh();

  


  private:
  Solver * solver;
  std::vector<Spring> springs;
  std::vector<glm::vec3> velocity;
  std::vector<glm::vec3> acceleration;
  std::vector<glm::vec3> force;
  std::vector<float> mass;
  SpringInfo springInfo;
  std::vector<Particle> particles;
  void initParticle(int index, int springIndex, bool isNeg);

  public:
  std::vector<float>* getVertex(){
    return &this->m_mesh->m_vertex;
  }
  std::vector<Spring>* getSprings(){
    return &this->springs;
  }
  std::vector<Particle>* getParticles(){
    return &this->particles;
  }
  std::vector<glm::vec3>* getVelocity(){
    return &this->velocity;
  }
  std::vector<glm::vec3>* getAcceleration(){
    return &this->acceleration;
  }
  std::vector<glm::vec3>* getForce(){
    return &this->force;
  }
  std::vector<float>* getMass(){
    return &this->mass;
  }
  SpringInfo* getSpringInfo(){
    return &this->springInfo;
  }


};

#endif