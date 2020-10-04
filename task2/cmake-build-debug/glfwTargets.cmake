
if(NOT TARGET glfw::glfw)
    add_library(glfw::glfw INTERFACE IMPORTED)
endif()

# Load the debug and release library finders
get_filename_component(_DIR "${CMAKE_CURRENT_LIST_FILE}" PATH)
file(GLOB CONFIG_FILES "${_DIR}/glfwTarget-*.cmake")

foreach(f ${CONFIG_FILES})
    include(${f})
endforeach()
