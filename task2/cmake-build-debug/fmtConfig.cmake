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

include(${CMAKE_CURRENT_LIST_DIR}/fmtTargets.cmake)

########## FIND PACKAGE DEPENDENCY ##########################################################
#############################################################################################

include(CMakeFindDependencyMacro)

########## TARGETS PROPERTIES ###############################################################
#############################################################################################
########## COMPONENT fmt-header-only TARGET PROPERTIES ######################################

set_property(TARGET fmt::fmt-header-only PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${fmt_fmt-header-only_LINK_LIBS_RELEASE} ${fmt_fmt-header-only_LINKER_FLAGS_LIST_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${fmt_fmt-header-only_LINK_LIBS_RELWITHDEBINFO} ${fmt_fmt-header-only_LINKER_FLAGS_LIST_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${fmt_fmt-header-only_LINK_LIBS_MINSIZEREL} ${fmt_fmt-header-only_LINKER_FLAGS_LIST_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${fmt_fmt-header-only_LINK_LIBS_DEBUG} ${fmt_fmt-header-only_LINKER_FLAGS_LIST_DEBUG}>)
set_property(TARGET fmt::fmt-header-only PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${fmt_fmt-header-only_INCLUDE_DIRS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${fmt_fmt-header-only_INCLUDE_DIRS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${fmt_fmt-header-only_INCLUDE_DIRS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${fmt_fmt-header-only_INCLUDE_DIRS_DEBUG}>)
set_property(TARGET fmt::fmt-header-only PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${fmt_fmt-header-only_COMPILE_DEFINITIONS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${fmt_fmt-header-only_COMPILE_DEFINITIONS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${fmt_fmt-header-only_COMPILE_DEFINITIONS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${fmt_fmt-header-only_COMPILE_DEFINITIONS_DEBUG}>)
set_property(TARGET fmt::fmt-header-only PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:
                     ${fmt_fmt-header-only_COMPILE_OPTIONS_C_RELEASE}
                     ${fmt_fmt-header-only_COMPILE_OPTIONS_CXX_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:
                     ${fmt_fmt-header-only_COMPILE_OPTIONS_C_RELWITHDEBINFO}
                     ${fmt_fmt-header-only_COMPILE_OPTIONS_CXX_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:
                     ${fmt_fmt-header-only_COMPILE_OPTIONS_C_MINSIZEREL}
                     ${fmt_fmt-header-only_COMPILE_OPTIONS_CXX_MINSIZEREL}>
                 $<$<CONFIG:Debug>:
                     ${fmt_fmt-header-only_COMPILE_OPTIONS_C_DEBUG}
                     ${fmt_fmt-header-only_COMPILE_OPTIONS_CXX_DEBUG}>)
set(fmt_fmt-header-only_TARGET_PROPERTIES TRUE)

########## GLOBAL TARGET PROPERTIES #########################################################

if(NOT fmt_fmt_TARGET_PROPERTIES)
    set_property(TARGET fmt::fmt PROPERTY INTERFACE_LINK_LIBRARIES
                     $<$<CONFIG:Release>:${fmt_COMPONENTS_RELEASE}>
                     $<$<CONFIG:RelWithDebInfo>:${fmt_COMPONENTS_RELWITHDEBINFO}>
                     $<$<CONFIG:MinSizeRel>:${fmt_COMPONENTS_MINSIZEREL}>
                     $<$<CONFIG:Debug>:${fmt_COMPONENTS_DEBUG}>)
endif()