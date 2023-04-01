#include "TissusObject.h"

void TissusObject::initParticle(int index, int springIndex, bool isNeg) {
  for(int j = 0; j < MAX_SPRING; j++) {
      if(particles[index].springs[j] == -1) {
        particles[index].springs[j] = springIndex;
        particles[index].isNegative[j] = isNeg;
        particles[index].nbSpring++;
        break;
      }
  }
}

Particle makeParticle() {
  Particle p;
  p.nbSpring = 0;
  for(int i = 0; i < MAX_SPRING; i++) {
    p.springs[i] = -1;
    p.isNegative[i] = false;
  }
  return p;
} 

TissusObject::TissusObject(const Tissus & t) : Object(t) {
  
  for(int i = 0; i < this->m_mesh->getVertexCount(); i++) {
    particles.push_back(makeParticle());
    velocity.push_back(glm::vec3(0,0,0));
    acceleration.push_back(glm::vec3(0,0,0));
    force.push_back(glm::vec3(0,0,0));
    if(i == t.divW * t.divH - t.divW || i == t.divW * t.divH - 1) mass.push_back(0);
    else mass.push_back(t.mass / (t.divW * t.divH));
  }

  

  springInfo = SpringInfo(10000, 0.01);
  springInfo.updateDampingFactor();

  float stiffness = springInfo.GetStiffness();
  float damping = springInfo.GetDamping();
  float DF = springInfo.GetDampingFactor();

  std::vector<uint> indices = this->m_mesh->getIndices();
  for (unsigned int i = 0; i < indices.size(); i+=6)
  {
    float L0 = glm::length(this->m_mesh->getVertex(indices[i]) - this->m_mesh->getVertex(indices[i+1]));
    Spring s = {i, indices[i], indices[i+1], L0, stiffness, damping, DF};
    springs.push_back(s);

    initParticle(indices[i], springs.size()-1, true);
    initParticle(indices[i+1], springs.size()-1, false);

    L0 = glm::length(this->m_mesh->getVertex(indices[i]) - this->m_mesh->getVertex(indices[i+2]));
    s = {i+1, indices[i], indices[i+2], L0, stiffness, damping, DF};
    springs.push_back(s);

    initParticle(indices[i], springs.size()-1, true);
    initParticle(indices[i+2], springs.size()-1, false);

    L0 = glm::length(this->m_mesh->getVertex(indices[i+5]) - this->m_mesh->getVertex(indices[i+3]));
    s = {i+2, indices[i+5], indices[i+3], L0, stiffness, damping, DF};
    springs.push_back(s);

    initParticle(indices[i+5], springs.size()-1, true);
    initParticle(indices[i+3], springs.size()-1, false);

    L0 = glm::length(this->m_mesh->getVertex(indices[i+5]) - this->m_mesh->getVertex(indices[i+4]));
    s = {i+3, indices[i+5], indices[i+4], L0, stiffness, damping, DF};
    springs.push_back(s);

    initParticle(indices[i+5], springs.size()-1, true);
    initParticle(indices[i+4], springs.size()-1, false);
    
  }

  // for(int i = 0; i < this->m_mesh->getVertexCount(); i++) {
  //   std::cout<<"[";
  //   for(int j = 0; j < particles[i].nbSpring; j++) {
  //     std::cout<<particles[i].isNegative[j];
  //     if(j != particles[i].nbSpring-1) std::cout<<",";
  //   }
  //   std::cout<<"]"<<std::endl;
  // }
}

TissusObject& TissusObject::setSolver(Solver * s) {
  solver = s;
  return *this;
}

void TissusObject::update(int Tps)
{
  solver->update(Tps);
  this->updateMesh();
}

void TissusObject::updateMesh()
{
  //this->m_mesh->updateBuffer();
  switch (this->solver->getType())
  {
  case SolverType::SOLVER_CPU:
    this->m_mesh->updateBuffer();
    break;
  
  default:
    break;
  }
}

uint TissusObject::getVBO() const
{
  return m_mesh->getVBO();
}