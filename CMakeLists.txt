cmake_minimum_required(VERSION 3.8)
project(Physx-Test LANGUAGES C CXX CUDA)
set(CMAKE_BUILD_TYPE RELEASE)
find_package(glfw3 REQUIRED)
find_package(OpenGL REQUIRED)
find_package(GLUT REQUIRED)
find_package(GLEW REQUIRED)
find_package(glm REQUIRED)
find_package(OpenMP REQUIRED)

set (LOCAL_DIR ./src)
set (LIB_DIR ./lib)

include_directories(./src/include)
include_directories(lib)
add_subdirectory(lib)

set(SRCS
    ${LOCAL_DIR}/Camera.cu
    ${LOCAL_DIR}/Engine.cu
    ${LOCAL_DIR}/main.cu
    ${LOCAL_DIR}/Mesh.cu
    ${LOCAL_DIR}/Object.cu
    ${LOCAL_DIR}/Shader.cu
    ${LOCAL_DIR}/Textures.cu
    ${LOCAL_DIR}/Window.cu
    ${LOCAL_DIR}/World.cu
    ${LOCAL_DIR}/SpringInfo.cu
    ${LOCAL_DIR}/Spring.cu
    ${LOCAL_DIR}/SolverExplicitCPU.cu
    ${LOCAL_DIR}/SolverExplicitGPU.cu
    ${LOCAL_DIR}/TissusObject.cu
    ${LOCAL_DIR}/include/Shape.h
)


set(outputName run)
add_executable(${outputName} ${LIBSRCS} ${SRCS})
target_include_directories(${outputName} PUBLIC ${OPENGL_INCLUDE_DIR})
target_include_directories(${outputName} PUBLIC ${GLUT_INCLUDE_DIR})
target_link_libraries(${outputName} PUBLIC glfw ${OPENGL_gl_LIBRARY} )
target_link_libraries(${outputName} PUBLIC glut)
target_link_libraries(${outputName} PUBLIC GLU)
target_link_libraries(${outputName} PUBLIC GLEW)
target_link_libraries(${outputName} PUBLIC FastNoise)
target_link_libraries(${outputName} PUBLIC glad)
target_link_libraries(${outputName} PUBLIC lodepng)
target_link_libraries(${outputName} PUBLIC glfw OpenGL::GL ${CMAKE_DL_LIBS})
target_link_libraries(${outputName} PUBLIC OpenMP::OpenMP_CXX)

file(COPY data DESTINATION ${CMAKE_BINARY_DIR})
file(COPY shaders DESTINATION ${CMAKE_BINARY_DIR})
