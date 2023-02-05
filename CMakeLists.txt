cmake_minimum_required(VERSION 3.8)
project(Physx-Test)
set(CMAKE_BUILD_TYPE RELEASE)
find_package(glfw3 REQUIRED)
find_package(OpenGL REQUIRED)
find_package(GLUT REQUIRED)
find_package(GLEW REQUIRED)


include_directories(include)

set(SRCS
    ./src/src/main.cpp
)

set(outputName run)

add_executable(${outputName} ${SRCS})
target_include_directories(${outputName} PUBLIC ${OPENGL_INCLUDE_DIR})
target_include_directories(${outputName} PUBLIC ${GLUT_INCLUDE_DIR})
target_link_libraries(${outputName} PUBLIC glfw ${OPENGL_gl_LIBRARY})
target_link_libraries(${outputName} PUBLIC glut)
target_link_libraries(${outputName} PUBLIC GLU)
target_link_libraries(${outputName} PUBLIC GLEW)

