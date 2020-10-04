########## MACROS ###########################################################################
#############################################################################################

function(conan_message MESSAGE_OUTPUT)
    if(NOT CONAN_CMAKE_SILENT_OUTPUT)
        message(${ARGV${0}})
    endif()
endfunction()


# Requires CMake > 3.0
if(${CMAKE_VERSION} VERSION_LESS "3.0")
    message(FATAL_ERROR "The 'cmake_find_package_multi' generator only works with CMake > 3.0")
endif()

include(${CMAKE_CURRENT_LIST_DIR}/glewTargets.cmake)

########## FIND PACKAGE DEPENDENCY ##########################################################
#############################################################################################

include(CMakeFindDependencyMacro)

if(NOT opengl_system_FOUND)
    if(${CMAKE_VERSION} VERSION_LESS "3.9.0")
        find_package(opengl_system REQUIRED NO_MODULE)
    else()
        find_dependency(opengl_system REQUIRED NO_MODULE)
    endif()
else()
    message(STATUS "Dependency opengl_system already found")
endif()

if(NOT glu_FOUND)
    if(${CMAKE_VERSION} VERSION_LESS "3.9.0")
        find_package(glu REQUIRED NO_MODULE)
    else()
        find_dependency(glu REQUIRED NO_MODULE)
    endif()
else()
    message(STATUS "Dependency glu already found")
endif()

########## TARGETS PROPERTIES ###############################################################
#############################################################################################
########## COMPONENT glew_s TARGET PROPERTIES ######################################

set_property(TARGET GLEW::glew_s PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${GLEW_glew_s_LINK_LIBS_RELEASE} ${GLEW_glew_s_LINKER_FLAGS_LIST_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${GLEW_glew_s_LINK_LIBS_RELWITHDEBINFO} ${GLEW_glew_s_LINKER_FLAGS_LIST_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${GLEW_glew_s_LINK_LIBS_MINSIZEREL} ${GLEW_glew_s_LINKER_FLAGS_LIST_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${GLEW_glew_s_LINK_LIBS_DEBUG} ${GLEW_glew_s_LINKER_FLAGS_LIST_DEBUG}>)
set_property(TARGET GLEW::glew_s PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${GLEW_glew_s_INCLUDE_DIRS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${GLEW_glew_s_INCLUDE_DIRS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${GLEW_glew_s_INCLUDE_DIRS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${GLEW_glew_s_INCLUDE_DIRS_DEBUG}>)
set_property(TARGET GLEW::glew_s PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${GLEW_glew_s_COMPILE_DEFINITIONS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${GLEW_glew_s_COMPILE_DEFINITIONS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${GLEW_glew_s_COMPILE_DEFINITIONS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${GLEW_glew_s_COMPILE_DEFINITIONS_DEBUG}>)
set_property(TARGET GLEW::glew_s PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:
                     ${GLEW_glew_s_COMPILE_OPTIONS_C_RELEASE}
                     ${GLEW_glew_s_COMPILE_OPTIONS_CXX_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:
                     ${GLEW_glew_s_COMPILE_OPTIONS_C_RELWITHDEBINFO}
                     ${GLEW_glew_s_COMPILE_OPTIONS_CXX_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:
                     ${GLEW_glew_s_COMPILE_OPTIONS_C_MINSIZEREL}
                     ${GLEW_glew_s_COMPILE_OPTIONS_CXX_MINSIZEREL}>
                 $<$<CONFIG:Debug>:
                     ${GLEW_glew_s_COMPILE_OPTIONS_C_DEBUG}
                     ${GLEW_glew_s_COMPILE_OPTIONS_CXX_DEBUG}>)
set(GLEW_glew_s_TARGET_PROPERTIES TRUE)

########## GLOBAL TARGET PROPERTIES #########################################################

if(NOT GLEW_GLEW_TARGET_PROPERTIES)
    set_property(TARGET GLEW::GLEW PROPERTY INTERFACE_LINK_LIBRARIES
                     $<$<CONFIG:Release>:${GLEW_COMPONENTS_RELEASE}>
                     $<$<CONFIG:RelWithDebInfo>:${GLEW_COMPONENTS_RELWITHDEBINFO}>
                     $<$<CONFIG:MinSizeRel>:${GLEW_COMPONENTS_MINSIZEREL}>
                     $<$<CONFIG:Debug>:${GLEW_COMPONENTS_DEBUG}>)
endif()