
if(NOT TARGET opengl::opengl)
    add_library(opengl::opengl INTERFACE IMPORTED)
endif()

# Load the debug and release library finders
get_filename_component(_DIR "${CMAKE_CURRENT_LIST_FILE}" PATH)
file(GLOB CONFIG_FILES "${_DIR}/opengl_systemTarget-*.cmake")

foreach(f ${CONFIG_FILES})
    include(${f})
endforeach()
