

if(NOT TARGET GLEW::glew_s)
    add_library(GLEW::glew_s INTERFACE IMPORTED)
endif()

if(NOT TARGET GLEW::GLEW)
    add_library(GLEW::GLEW INTERFACE IMPORTED)
endif()

# Load the debug and release library finders
get_filename_component(_DIR "${CMAKE_CURRENT_LIST_FILE}" PATH)
file(GLOB CONFIG_FILES "${_DIR}/glewTarget-*.cmake")

foreach(f ${CONFIG_FILES})
    include(${f})
endforeach()

if(GLEW_FIND_COMPONENTS)
    foreach(_FIND_COMPONENT ${GLEW_FIND_COMPONENTS})
        list(FIND GLEW_COMPONENTS_RELEASE "GLEW::${_FIND_COMPONENT}" _index)
        if(${_index} EQUAL -1)
            conan_message(FATAL_ERROR "Conan: Component '${_FIND_COMPONENT}' NOT found in package 'GLEW'")
        else()
            conan_message(STATUS "Conan: Component '${_FIND_COMPONENT}' found in package 'GLEW'")
        endif()
    endforeach()
endif()