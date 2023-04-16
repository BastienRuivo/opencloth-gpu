# Simulation de tissus sur GPU

# Auteurs

Bastien RUIVO
Dylan JEANNIN

# Contenu

Ce projet porte sur la simulation de tissus sur GPU et CPU, et tente de comparer les performances entre les deux méthodes.
Nous avons implémenté le solver Euler Explicit nous même, sur processeur comme sur carte graphique, car les librairies que nous avions trouvées étaient de véritables boîtes noires en terme de code, ce qui ne nous a pas aidé à développer notre solver.

Pour les librairies que nous avions cherché, il y avait notamment Nvidia-Flex, NVCloth et, développé très récemment, PhysX5, mais nous avons renoncé à toutes ces librairies après avoir remarqué qu'elles étaient peu documentées et que leur partie GPU n'était pas accessible.

Nous avons donc implémenté nos solvers sur un petit moteur graphique déjà élaboré lors d'un projet précédent, et il ne nous restait plus qu'à y incorporer nos tissus, nos solvers, et y lancer nos simulations.

# Installation

Pour installer la simulation, il suffit de cloner le projet, puis d'y créer un répertoire build et de lancer la commande `cmake ..` dans ce répertoire.

Certaines librairies doivent au préalable être installées, notamment :
glfw3 -> ` sudo apt-get install libglfw3 `
opengl -> ` sudo apt-get install freeglut3 `
stb -> ` sudo apt-get install libstb-dev `
glew -> ` sudo apt-get install libglew-dev `
glm -> ` sudo apt-get install libglm-dev `
openmp -> ` sudo apt-get install libomp-dev `
et bien évidemment, pour les calculs sur GPU, cuda -> ` sudo apt install nvidia-cuda-toolkit `

A savoir que notre projet ne fonctionne qu'avec des cartes graphiques NVidia, puisque Cuda est développé par NVidia, pour NVidia.

# Articles de recherche importants