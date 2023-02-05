cmake_minimum_required(VERSION 3.8)
project(Physx-Test)
set(CMAKE_BUILD_TYPE RELEASE)
enable_language(CUDA)

find_package(CUDAToolkit REQUIRED)
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
target_link_libraries(${outputName} PRIVATE CUDA::cudart_static)
target_link_libraries(${outputName} PRIVATE CUDA::cuda_driver)
if(${CMAKE_BUILD_TYPE} EQUAL "DEBUG")
    target_link_libraries(${outputName} PUBLIC ${DEBUG_PHYSX})
    add_compile_definitions(RENDER_SNIPPET)
    remove_definitions("NDEBUG")
else() 
    target_link_libraries(${outputName} PUBLIC ${RELEASE_PHYSX})
    
    add_compile_definitions(NDEBUG)
    add_compile_definitions(RENDER_SNIPPET)
endif()

