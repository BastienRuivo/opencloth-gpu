cmake_minimum_required(VERSION 3.8)
project(Physx-Test)
set(CMAKE_BUILD_TYPE RELEASE)
find_package(glfw3 REQUIRED)
find_package(OpenGL REQUIRED)
find_package(GLUT REQUIRED)
find_package(GLEW REQUIRED)


include_directories(./src/include)
include_directories(lib)
add_subdirectory(lib)

set(SRCS
    ./src/main.cpp
    ./src/Shader.cpp
    ./src/Textures.cpp
    ./src/Objects.cpp
    ./src/Object.cpp
    ./src/Camera.cpp
    ./src/Window.cpp
    ./src/Engine.cpp
    ./src/Mesh.cpp
    ./src/World.cpp
)

set(outputName run)

add_executable(${outputName} ${SRCS})
target_include_directories(${outputName} PUBLIC ${OPENGL_INCLUDE_DIR})
target_include_directories(${outputName} PUBLIC ${GLUT_INCLUDE_DIR})
target_link_libraries(${outputName} PUBLIC glfw ${OPENGL_gl_LIBRARY})
target_link_libraries(${outputName} PUBLIC glut)
target_link_libraries(${outputName} PUBLIC GLU)
target_link_libraries(${outputName} PUBLIC GLEW)
target_link_libraries(${outputName} PUBLIC FastNoise)
target_link_libraries(${outputName} PUBLIC glad)
target_link_libraries(${outputName} PUBLIC imgui)
target_link_libraries(${outputName} PUBLIC lodepng)
target_link_libraries(${outputName} PUBLIC stb_image)

file(COPY data DESTINATION ${CMAKE_BINARY_DIR})
file(COPY shaders DESTINATION ${CMAKE_BINARY_DIR})
