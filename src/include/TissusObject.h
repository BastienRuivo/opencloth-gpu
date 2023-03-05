#ifndef TISSUSOBJECT_H
#define TISSUSOBJECT_H


#include "Object.h"
#include "Solver.h"

class TissusObject : public Object 
{
  public:
  TissusObject(const Tissus & t, Solver *solver);
  void update(int Tps);
  void updateMesh();

  private:
  Solver * solver;
  std::vector<Spring> springs;
  std::vector<glm::vec3> position;
  std::vector<glm::vec3> velocity;
  std::vector<glm::vec3> acceleration;
  std::vector<glm::vec3> force;
  std::vector<float> mass;
  SpringInfo springInfo;

};

#endif