#include "TissusObject.h"

TissusObject::TissusObject(const Tissus & t, Solver * solv) : Object(t) {
  solver = solv;
  for(int i = 0; i < this->m_mesh->getVertexCount(); i++) {
    position.push_back(this->m_mesh->getVertex(i));
    velocity.push_back(glm::vec3(0,0,0));
    acceleration.push_back(glm::vec3(0,0,0));
    force.push_back(glm::vec3(0,0,0));
    if(i == t.divW * t.divH - t.divW || i == t.divW * t.divH - 1) mass.push_back(0);
    else mass.push_back(1);
  }

  springInfo = SpringInfo(30000, 0.01);

  std::vector<uint> indices = this->m_mesh->getIndices();
  for (int i = 0; i < indices.size(); i+=3)
  {
    double L0 = glm::length(position[indices[i]] - position[indices[i+1]]);
    springs.push_back(new Spring(indices[i], indices[i+1], &springInfo, L0));
    L0 = glm::length(position[indices[i+1]] - position[indices[i+2]]);
    springs.push_back(new Spring(indices[i+1], indices[i+2], &springInfo, L0));
    L0 = glm::length(position[indices[i+2]] - position[indices[i]]);
    springs.push_back(new Spring(indices[i+2], indices[i], &springInfo, L0));

    
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