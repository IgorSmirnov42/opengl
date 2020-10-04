
if(NOT TARGET glm::glm)
    add_library(glm::glm INTERFACE IMPORTED)
endif()

# Load the debug and release library finders
get_filename_component(_DIR "${CMAKE_CURRENT_LIST_FILE}" PATH)
file(GLOB CONFIG_FILES "${_DIR}/glmTarget-*.cmake")

foreach(f ${CONFIG_FILES})
    include(${f})
endforeach()
