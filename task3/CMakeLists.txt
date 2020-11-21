cmake_minimum_required(VERSION 3.0)
project(3Dscene CXX)

set(CMAKE_CXX_STANDARD 17)

set(CMAKE_PREFIX_PATH ${CMAKE_BINARY_DIR})
set(CMAKE_MODULE_PATH ${CMAKE_BINARY_DIR})

#include_directories(
#        /home/smirnov-i/.conan/data/imgui/1.74/_/_/package/50a5030bbbb13ae56bc4be41915ecd48549cb895/include/
#        /home/smirnov-i/.conan/data/glew/2.1.0/_/_/package/161ee116d0f37f134c366b5832500f2812dc7b50/include/
#        /home/smirnov-i/.conan/data/fmt/7.0.3/_/_/package/5ab84d6acfe1f23c4fae0ab88f26e3a396351ac9/include/
#        /home/smirnov-i/.conan/data/glfw/3.3.2/_/_/package/6340505dafa41af473a127b95b9c69164d638b69/include/
#        /home/smirnov-i/.conan/data/glm/0.9.9.8/_/_/package/5ab84d6acfe1f23c4fae0ab88f26e3a396351ac9/include/
#)

# CONFIG option is important so that CMake doesnt search for modules into the default modules directory
find_package(imgui REQUIRED CONFIG)
find_package(glfw REQUIRED CONFIG)
find_package(glew REQUIRED CONFIG)
find_package(fmt REQUIRED CONFIG)
find_package(glm REQUIRED CONFIG)

add_executable( 3Dscene
                main.cpp
                opengl_shader.cpp
                opengl_shader.h
                libs/stb_image.h
                libs/tiny_obj_loader.h
                bindings/imgui_impl_glfw.cpp
                bindings/imgui_impl_opengl3.cpp
                bindings/imgui_impl_glfw.h
                bindings/imgui_impl_opengl3.h
                assets/cubemap-shader.vs
                assets/cubemap-shader.fs
                assets/boat-shader.vs
                assets/boat-shader.fs
                assets/water-shader.fs
                assets/water-shader.vs
                assets/landscape-shader.fs
                assets/landscape-shader.vs
                assets/lighthouse-shader.vs
                assets/lighthouse-shader.fs
                assets/object-preshader.vs
                assets/object-preshader.fs
                assets/water-preshader.vs)

add_custom_command(TARGET 3Dscene
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy ${PROJECT_SOURCE_DIR}/assets/cubemap-shader.vs ${PROJECT_BINARY_DIR}
    COMMAND ${CMAKE_COMMAND} -E copy ${PROJECT_SOURCE_DIR}/assets/cubemap-shader.fs ${PROJECT_BINARY_DIR}
    COMMAND ${CMAKE_COMMAND} -E copy ${PROJECT_SOURCE_DIR}/assets/boat-shader.vs ${PROJECT_BINARY_DIR}
    COMMAND ${CMAKE_COMMAND} -E copy ${PROJECT_SOURCE_DIR}/assets/boat-shader.fs ${PROJECT_BINARY_DIR}
    COMMAND ${CMAKE_COMMAND} -E copy ${PROJECT_SOURCE_DIR}/assets/lighthouse-shader.vs ${PROJECT_BINARY_DIR}
    COMMAND ${CMAKE_COMMAND} -E copy ${PROJECT_SOURCE_DIR}/assets/lighthouse-shader.fs ${PROJECT_BINARY_DIR}
    COMMAND ${CMAKE_COMMAND} -E copy ${PROJECT_SOURCE_DIR}/assets/object-preshader.vs ${PROJECT_BINARY_DIR}
    COMMAND ${CMAKE_COMMAND} -E copy ${PROJECT_SOURCE_DIR}/assets/object-preshader.fs ${PROJECT_BINARY_DIR}
    COMMAND ${CMAKE_COMMAND} -E copy ${PROJECT_SOURCE_DIR}/assets/water-shader.vs ${PROJECT_BINARY_DIR}
    COMMAND ${CMAKE_COMMAND} -E copy ${PROJECT_SOURCE_DIR}/assets/water-shader.fs ${PROJECT_BINARY_DIR}
    COMMAND ${CMAKE_COMMAND} -E copy ${PROJECT_SOURCE_DIR}/assets/landscape-shader.vs ${PROJECT_BINARY_DIR}
    COMMAND ${CMAKE_COMMAND} -E copy ${PROJECT_SOURCE_DIR}/assets/landscape-shader.fs ${PROJECT_BINARY_DIR}
    COMMAND ${CMAKE_COMMAND} -E copy ${PROJECT_SOURCE_DIR}/assets/water-preshader.vs ${PROJECT_BINARY_DIR}
)

target_compile_definitions(3Dscene PUBLIC IMGUI_IMPL_OPENGL_LOADER_GLEW)
target_link_libraries(3Dscene imgui::imgui GLEW::glew_s glfw::glfw fmt::fmt glm::glm)