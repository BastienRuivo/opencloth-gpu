#include "TissusObject.h"

TissusObject::TissusObject(const Tissus & t, Solver * solv) : Object(t) {
  solver = solv;
  for(int i = 0; i < this->m_mesh->getVertexCount(); i++) {
    position.push_back(this->m_mesh->getVertex(i));
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
  for (unsigned int i = 0; i < indices.size(); i+=3)
  {
    float L0 = glm::length(position[indices[i]] - position[indices[i+1]]);
    Spring s = {i, indices[i], indices[i+1], L0, stiffness, damping, DF};
    springs.push_back(s);

    L0 = glm::length(position[indices[i+1]] - position[indices[i+2]]);
    s = {i+1, indices[i+1], indices[i+2], L0, stiffness, damping, DF};
    springs.push_back(s);

    L0 = glm::length(position[indices[i+2]] - position[indices[i]]);
    s = {i+2, indices[i+2], indices[i], L0, stiffness, damping, DF};
    springs.push_back(s);

    
  }
  
  solver->setData(&springs, &position, &velocity, &acceleration, &force, &mass);
}

void TissusObject::update(int Tps)
{
    solver->update(Tps);
    this->updateMesh();
}

void TissusObject::updateMesh()
{
  this->m_mesh->updateVertex(position);
}