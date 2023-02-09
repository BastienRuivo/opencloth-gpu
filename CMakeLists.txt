cmake_minimum_required(VERSION 3.8)
project(Physx-Test)
set(CMAKE_BUILD_TYPE RELEASE)
find_package(glfw3 REQUIRED)
find_package(OpenGL REQUIRED)
find_package(GLUT REQUIRED)
find_package(GLEW REQUIRED)
find_package(imgui REQUIRED)
find_package(glm REQUIRED)

set (LOCAL_DIR ./src)
set (LIB_DIR ./lib)

include_directories(./src/include)
include_directories(lib)
add_subdirectory(lib)

set(SRCS
    ${LOCAL_DIR}/imgui_impl_glfw.cpp
    ${LOCAL_DIR}/imgui_impl_opengl3.cpp
    ${LOCAL_DIR}/include/imgui_impl_glfw.h
    ${LOCAL_DIR}/include/imgui_impl_opengl3.h
    ${LOCAL_DIR}/include/imgui_impl_opengl3_loader.h
    ${LOCAL_DIR}/Camera.cpp
    ${LOCAL_DIR}/Engine.cpp
    ${LOCAL_DIR}/main.cpp
    ${LOCAL_DIR}/Mesh.cpp
    ${LOCAL_DIR}/Object.cpp
    ${LOCAL_DIR}/Shader.cpp
    ${LOCAL_DIR}/Textures.cpp
    ${LOCAL_DIR}/Window.cpp
    ${LOCAL_DIR}/World.cpp
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
target_link_libraries(${outputName} PUBLIC imgui::imgui)
target_link_libraries(${outputName} PUBLIC lodepng)
target_link_libraries(${outputName} PUBLIC glfw OpenGL::GL ${CMAKE_DL_LIBS})

file(COPY data DESTINATION ${CMAKE_BINARY_DIR})
file(COPY shaders DESTINATION ${CMAKE_BINARY_DIR})
