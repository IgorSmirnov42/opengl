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

include(${CMAKE_CURRENT_LIST_DIR}/xorgTargets.cmake)

########## FIND PACKAGE DEPENDENCY ##########################################################
#############################################################################################

include(CMakeFindDependencyMacro)

########## TARGETS PROPERTIES ###############################################################
#############################################################################################
########## COMPONENT xkeyboard-config TARGET PROPERTIES ######################################

set_property(TARGET xorg::xkeyboard-config PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${xorg_xkeyboard-config_LINK_LIBS_RELEASE} ${xorg_xkeyboard-config_LINKER_FLAGS_LIST_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xkeyboard-config_LINK_LIBS_RELWITHDEBINFO} ${xorg_xkeyboard-config_LINKER_FLAGS_LIST_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xkeyboard-config_LINK_LIBS_MINSIZEREL} ${xorg_xkeyboard-config_LINKER_FLAGS_LIST_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xkeyboard-config_LINK_LIBS_DEBUG} ${xorg_xkeyboard-config_LINKER_FLAGS_LIST_DEBUG}>)
set_property(TARGET xorg::xkeyboard-config PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${xorg_xkeyboard-config_INCLUDE_DIRS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xkeyboard-config_INCLUDE_DIRS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xkeyboard-config_INCLUDE_DIRS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xkeyboard-config_INCLUDE_DIRS_DEBUG}>)
set_property(TARGET xorg::xkeyboard-config PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${xorg_xkeyboard-config_COMPILE_DEFINITIONS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xkeyboard-config_COMPILE_DEFINITIONS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xkeyboard-config_COMPILE_DEFINITIONS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xkeyboard-config_COMPILE_DEFINITIONS_DEBUG}>)
set_property(TARGET xorg::xkeyboard-config PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:
                     ${xorg_xkeyboard-config_COMPILE_OPTIONS_C_RELEASE}
                     ${xorg_xkeyboard-config_COMPILE_OPTIONS_CXX_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:
                     ${xorg_xkeyboard-config_COMPILE_OPTIONS_C_RELWITHDEBINFO}
                     ${xorg_xkeyboard-config_COMPILE_OPTIONS_CXX_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:
                     ${xorg_xkeyboard-config_COMPILE_OPTIONS_C_MINSIZEREL}
                     ${xorg_xkeyboard-config_COMPILE_OPTIONS_CXX_MINSIZEREL}>
                 $<$<CONFIG:Debug>:
                     ${xorg_xkeyboard-config_COMPILE_OPTIONS_C_DEBUG}
                     ${xorg_xkeyboard-config_COMPILE_OPTIONS_CXX_DEBUG}>)
set(xorg_xkeyboard-config_TARGET_PROPERTIES TRUE)
########## COMPONENT xcb TARGET PROPERTIES ######################################

set_property(TARGET xorg::xcb PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${xorg_xcb_LINK_LIBS_RELEASE} ${xorg_xcb_LINKER_FLAGS_LIST_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xcb_LINK_LIBS_RELWITHDEBINFO} ${xorg_xcb_LINKER_FLAGS_LIST_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xcb_LINK_LIBS_MINSIZEREL} ${xorg_xcb_LINKER_FLAGS_LIST_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xcb_LINK_LIBS_DEBUG} ${xorg_xcb_LINKER_FLAGS_LIST_DEBUG}>)
set_property(TARGET xorg::xcb PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${xorg_xcb_INCLUDE_DIRS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xcb_INCLUDE_DIRS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xcb_INCLUDE_DIRS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xcb_INCLUDE_DIRS_DEBUG}>)
set_property(TARGET xorg::xcb PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${xorg_xcb_COMPILE_DEFINITIONS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xcb_COMPILE_DEFINITIONS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xcb_COMPILE_DEFINITIONS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xcb_COMPILE_DEFINITIONS_DEBUG}>)
set_property(TARGET xorg::xcb PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:
                     ${xorg_xcb_COMPILE_OPTIONS_C_RELEASE}
                     ${xorg_xcb_COMPILE_OPTIONS_CXX_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:
                     ${xorg_xcb_COMPILE_OPTIONS_C_RELWITHDEBINFO}
                     ${xorg_xcb_COMPILE_OPTIONS_CXX_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:
                     ${xorg_xcb_COMPILE_OPTIONS_C_MINSIZEREL}
                     ${xorg_xcb_COMPILE_OPTIONS_CXX_MINSIZEREL}>
                 $<$<CONFIG:Debug>:
                     ${xorg_xcb_COMPILE_OPTIONS_C_DEBUG}
                     ${xorg_xcb_COMPILE_OPTIONS_CXX_DEBUG}>)
set(xorg_xcb_TARGET_PROPERTIES TRUE)
########## COMPONENT xcb-xinerama TARGET PROPERTIES ######################################

set_property(TARGET xorg::xcb-xinerama PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${xorg_xcb-xinerama_LINK_LIBS_RELEASE} ${xorg_xcb-xinerama_LINKER_FLAGS_LIST_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xcb-xinerama_LINK_LIBS_RELWITHDEBINFO} ${xorg_xcb-xinerama_LINKER_FLAGS_LIST_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xcb-xinerama_LINK_LIBS_MINSIZEREL} ${xorg_xcb-xinerama_LINKER_FLAGS_LIST_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xcb-xinerama_LINK_LIBS_DEBUG} ${xorg_xcb-xinerama_LINKER_FLAGS_LIST_DEBUG}>)
set_property(TARGET xorg::xcb-xinerama PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${xorg_xcb-xinerama_INCLUDE_DIRS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xcb-xinerama_INCLUDE_DIRS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xcb-xinerama_INCLUDE_DIRS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xcb-xinerama_INCLUDE_DIRS_DEBUG}>)
set_property(TARGET xorg::xcb-xinerama PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${xorg_xcb-xinerama_COMPILE_DEFINITIONS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xcb-xinerama_COMPILE_DEFINITIONS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xcb-xinerama_COMPILE_DEFINITIONS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xcb-xinerama_COMPILE_DEFINITIONS_DEBUG}>)
set_property(TARGET xorg::xcb-xinerama PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:
                     ${xorg_xcb-xinerama_COMPILE_OPTIONS_C_RELEASE}
                     ${xorg_xcb-xinerama_COMPILE_OPTIONS_CXX_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:
                     ${xorg_xcb-xinerama_COMPILE_OPTIONS_C_RELWITHDEBINFO}
                     ${xorg_xcb-xinerama_COMPILE_OPTIONS_CXX_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:
                     ${xorg_xcb-xinerama_COMPILE_OPTIONS_C_MINSIZEREL}
                     ${xorg_xcb-xinerama_COMPILE_OPTIONS_CXX_MINSIZEREL}>
                 $<$<CONFIG:Debug>:
                     ${xorg_xcb-xinerama_COMPILE_OPTIONS_C_DEBUG}
                     ${xorg_xcb-xinerama_COMPILE_OPTIONS_CXX_DEBUG}>)
set(xorg_xcb-xinerama_TARGET_PROPERTIES TRUE)
########## COMPONENT xcb-xfixes TARGET PROPERTIES ######################################

set_property(TARGET xorg::xcb-xfixes PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${xorg_xcb-xfixes_LINK_LIBS_RELEASE} ${xorg_xcb-xfixes_LINKER_FLAGS_LIST_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xcb-xfixes_LINK_LIBS_RELWITHDEBINFO} ${xorg_xcb-xfixes_LINKER_FLAGS_LIST_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xcb-xfixes_LINK_LIBS_MINSIZEREL} ${xorg_xcb-xfixes_LINKER_FLAGS_LIST_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xcb-xfixes_LINK_LIBS_DEBUG} ${xorg_xcb-xfixes_LINKER_FLAGS_LIST_DEBUG}>)
set_property(TARGET xorg::xcb-xfixes PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${xorg_xcb-xfixes_INCLUDE_DIRS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xcb-xfixes_INCLUDE_DIRS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xcb-xfixes_INCLUDE_DIRS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xcb-xfixes_INCLUDE_DIRS_DEBUG}>)
set_property(TARGET xorg::xcb-xfixes PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${xorg_xcb-xfixes_COMPILE_DEFINITIONS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xcb-xfixes_COMPILE_DEFINITIONS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xcb-xfixes_COMPILE_DEFINITIONS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xcb-xfixes_COMPILE_DEFINITIONS_DEBUG}>)
set_property(TARGET xorg::xcb-xfixes PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:
                     ${xorg_xcb-xfixes_COMPILE_OPTIONS_C_RELEASE}
                     ${xorg_xcb-xfixes_COMPILE_OPTIONS_CXX_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:
                     ${xorg_xcb-xfixes_COMPILE_OPTIONS_C_RELWITHDEBINFO}
                     ${xorg_xcb-xfixes_COMPILE_OPTIONS_CXX_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:
                     ${xorg_xcb-xfixes_COMPILE_OPTIONS_C_MINSIZEREL}
                     ${xorg_xcb-xfixes_COMPILE_OPTIONS_CXX_MINSIZEREL}>
                 $<$<CONFIG:Debug>:
                     ${xorg_xcb-xfixes_COMPILE_OPTIONS_C_DEBUG}
                     ${xorg_xcb-xfixes_COMPILE_OPTIONS_CXX_DEBUG}>)
set(xorg_xcb-xfixes_TARGET_PROPERTIES TRUE)
########## COMPONENT xcb-sync TARGET PROPERTIES ######################################

set_property(TARGET xorg::xcb-sync PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${xorg_xcb-sync_LINK_LIBS_RELEASE} ${xorg_xcb-sync_LINKER_FLAGS_LIST_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xcb-sync_LINK_LIBS_RELWITHDEBINFO} ${xorg_xcb-sync_LINKER_FLAGS_LIST_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xcb-sync_LINK_LIBS_MINSIZEREL} ${xorg_xcb-sync_LINKER_FLAGS_LIST_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xcb-sync_LINK_LIBS_DEBUG} ${xorg_xcb-sync_LINKER_FLAGS_LIST_DEBUG}>)
set_property(TARGET xorg::xcb-sync PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${xorg_xcb-sync_INCLUDE_DIRS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xcb-sync_INCLUDE_DIRS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xcb-sync_INCLUDE_DIRS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xcb-sync_INCLUDE_DIRS_DEBUG}>)
set_property(TARGET xorg::xcb-sync PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${xorg_xcb-sync_COMPILE_DEFINITIONS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xcb-sync_COMPILE_DEFINITIONS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xcb-sync_COMPILE_DEFINITIONS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xcb-sync_COMPILE_DEFINITIONS_DEBUG}>)
set_property(TARGET xorg::xcb-sync PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:
                     ${xorg_xcb-sync_COMPILE_OPTIONS_C_RELEASE}
                     ${xorg_xcb-sync_COMPILE_OPTIONS_CXX_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:
                     ${xorg_xcb-sync_COMPILE_OPTIONS_C_RELWITHDEBINFO}
                     ${xorg_xcb-sync_COMPILE_OPTIONS_CXX_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:
                     ${xorg_xcb-sync_COMPILE_OPTIONS_C_MINSIZEREL}
                     ${xorg_xcb-sync_COMPILE_OPTIONS_CXX_MINSIZEREL}>
                 $<$<CONFIG:Debug>:
                     ${xorg_xcb-sync_COMPILE_OPTIONS_C_DEBUG}
                     ${xorg_xcb-sync_COMPILE_OPTIONS_CXX_DEBUG}>)
set(xorg_xcb-sync_TARGET_PROPERTIES TRUE)
########## COMPONENT xcb-shm TARGET PROPERTIES ######################################

set_property(TARGET xorg::xcb-shm PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${xorg_xcb-shm_LINK_LIBS_RELEASE} ${xorg_xcb-shm_LINKER_FLAGS_LIST_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xcb-shm_LINK_LIBS_RELWITHDEBINFO} ${xorg_xcb-shm_LINKER_FLAGS_LIST_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xcb-shm_LINK_LIBS_MINSIZEREL} ${xorg_xcb-shm_LINKER_FLAGS_LIST_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xcb-shm_LINK_LIBS_DEBUG} ${xorg_xcb-shm_LINKER_FLAGS_LIST_DEBUG}>)
set_property(TARGET xorg::xcb-shm PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${xorg_xcb-shm_INCLUDE_DIRS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xcb-shm_INCLUDE_DIRS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xcb-shm_INCLUDE_DIRS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xcb-shm_INCLUDE_DIRS_DEBUG}>)
set_property(TARGET xorg::xcb-shm PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${xorg_xcb-shm_COMPILE_DEFINITIONS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xcb-shm_COMPILE_DEFINITIONS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xcb-shm_COMPILE_DEFINITIONS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xcb-shm_COMPILE_DEFINITIONS_DEBUG}>)
set_property(TARGET xorg::xcb-shm PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:
                     ${xorg_xcb-shm_COMPILE_OPTIONS_C_RELEASE}
                     ${xorg_xcb-shm_COMPILE_OPTIONS_CXX_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:
                     ${xorg_xcb-shm_COMPILE_OPTIONS_C_RELWITHDEBINFO}
                     ${xorg_xcb-shm_COMPILE_OPTIONS_CXX_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:
                     ${xorg_xcb-shm_COMPILE_OPTIONS_C_MINSIZEREL}
                     ${xorg_xcb-shm_COMPILE_OPTIONS_CXX_MINSIZEREL}>
                 $<$<CONFIG:Debug>:
                     ${xorg_xcb-shm_COMPILE_OPTIONS_C_DEBUG}
                     ${xorg_xcb-shm_COMPILE_OPTIONS_CXX_DEBUG}>)
set(xorg_xcb-shm_TARGET_PROPERTIES TRUE)
########## COMPONENT xcb-shape TARGET PROPERTIES ######################################

set_property(TARGET xorg::xcb-shape PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${xorg_xcb-shape_LINK_LIBS_RELEASE} ${xorg_xcb-shape_LINKER_FLAGS_LIST_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xcb-shape_LINK_LIBS_RELWITHDEBINFO} ${xorg_xcb-shape_LINKER_FLAGS_LIST_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xcb-shape_LINK_LIBS_MINSIZEREL} ${xorg_xcb-shape_LINKER_FLAGS_LIST_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xcb-shape_LINK_LIBS_DEBUG} ${xorg_xcb-shape_LINKER_FLAGS_LIST_DEBUG}>)
set_property(TARGET xorg::xcb-shape PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${xorg_xcb-shape_INCLUDE_DIRS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xcb-shape_INCLUDE_DIRS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xcb-shape_INCLUDE_DIRS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xcb-shape_INCLUDE_DIRS_DEBUG}>)
set_property(TARGET xorg::xcb-shape PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${xorg_xcb-shape_COMPILE_DEFINITIONS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xcb-shape_COMPILE_DEFINITIONS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xcb-shape_COMPILE_DEFINITIONS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xcb-shape_COMPILE_DEFINITIONS_DEBUG}>)
set_property(TARGET xorg::xcb-shape PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:
                     ${xorg_xcb-shape_COMPILE_OPTIONS_C_RELEASE}
                     ${xorg_xcb-shape_COMPILE_OPTIONS_CXX_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:
                     ${xorg_xcb-shape_COMPILE_OPTIONS_C_RELWITHDEBINFO}
                     ${xorg_xcb-shape_COMPILE_OPTIONS_CXX_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:
                     ${xorg_xcb-shape_COMPILE_OPTIONS_C_MINSIZEREL}
                     ${xorg_xcb-shape_COMPILE_OPTIONS_CXX_MINSIZEREL}>
                 $<$<CONFIG:Debug>:
                     ${xorg_xcb-shape_COMPILE_OPTIONS_C_DEBUG}
                     ${xorg_xcb-shape_COMPILE_OPTIONS_CXX_DEBUG}>)
set(xorg_xcb-shape_TARGET_PROPERTIES TRUE)
########## COMPONENT xcb-renderutil TARGET PROPERTIES ######################################

set_property(TARGET xorg::xcb-renderutil PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${xorg_xcb-renderutil_LINK_LIBS_RELEASE} ${xorg_xcb-renderutil_LINKER_FLAGS_LIST_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xcb-renderutil_LINK_LIBS_RELWITHDEBINFO} ${xorg_xcb-renderutil_LINKER_FLAGS_LIST_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xcb-renderutil_LINK_LIBS_MINSIZEREL} ${xorg_xcb-renderutil_LINKER_FLAGS_LIST_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xcb-renderutil_LINK_LIBS_DEBUG} ${xorg_xcb-renderutil_LINKER_FLAGS_LIST_DEBUG}>)
set_property(TARGET xorg::xcb-renderutil PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${xorg_xcb-renderutil_INCLUDE_DIRS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xcb-renderutil_INCLUDE_DIRS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xcb-renderutil_INCLUDE_DIRS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xcb-renderutil_INCLUDE_DIRS_DEBUG}>)
set_property(TARGET xorg::xcb-renderutil PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${xorg_xcb-renderutil_COMPILE_DEFINITIONS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xcb-renderutil_COMPILE_DEFINITIONS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xcb-renderutil_COMPILE_DEFINITIONS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xcb-renderutil_COMPILE_DEFINITIONS_DEBUG}>)
set_property(TARGET xorg::xcb-renderutil PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:
                     ${xorg_xcb-renderutil_COMPILE_OPTIONS_C_RELEASE}
                     ${xorg_xcb-renderutil_COMPILE_OPTIONS_CXX_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:
                     ${xorg_xcb-renderutil_COMPILE_OPTIONS_C_RELWITHDEBINFO}
                     ${xorg_xcb-renderutil_COMPILE_OPTIONS_CXX_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:
                     ${xorg_xcb-renderutil_COMPILE_OPTIONS_C_MINSIZEREL}
                     ${xorg_xcb-renderutil_COMPILE_OPTIONS_CXX_MINSIZEREL}>
                 $<$<CONFIG:Debug>:
                     ${xorg_xcb-renderutil_COMPILE_OPTIONS_C_DEBUG}
                     ${xorg_xcb-renderutil_COMPILE_OPTIONS_CXX_DEBUG}>)
set(xorg_xcb-renderutil_TARGET_PROPERTIES TRUE)
########## COMPONENT xcb-render TARGET PROPERTIES ######################################

set_property(TARGET xorg::xcb-render PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${xorg_xcb-render_LINK_LIBS_RELEASE} ${xorg_xcb-render_LINKER_FLAGS_LIST_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xcb-render_LINK_LIBS_RELWITHDEBINFO} ${xorg_xcb-render_LINKER_FLAGS_LIST_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xcb-render_LINK_LIBS_MINSIZEREL} ${xorg_xcb-render_LINKER_FLAGS_LIST_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xcb-render_LINK_LIBS_DEBUG} ${xorg_xcb-render_LINKER_FLAGS_LIST_DEBUG}>)
set_property(TARGET xorg::xcb-render PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${xorg_xcb-render_INCLUDE_DIRS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xcb-render_INCLUDE_DIRS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xcb-render_INCLUDE_DIRS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xcb-render_INCLUDE_DIRS_DEBUG}>)
set_property(TARGET xorg::xcb-render PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${xorg_xcb-render_COMPILE_DEFINITIONS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xcb-render_COMPILE_DEFINITIONS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xcb-render_COMPILE_DEFINITIONS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xcb-render_COMPILE_DEFINITIONS_DEBUG}>)
set_property(TARGET xorg::xcb-render PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:
                     ${xorg_xcb-render_COMPILE_OPTIONS_C_RELEASE}
                     ${xorg_xcb-render_COMPILE_OPTIONS_CXX_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:
                     ${xorg_xcb-render_COMPILE_OPTIONS_C_RELWITHDEBINFO}
                     ${xorg_xcb-render_COMPILE_OPTIONS_CXX_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:
                     ${xorg_xcb-render_COMPILE_OPTIONS_C_MINSIZEREL}
                     ${xorg_xcb-render_COMPILE_OPTIONS_CXX_MINSIZEREL}>
                 $<$<CONFIG:Debug>:
                     ${xorg_xcb-render_COMPILE_OPTIONS_C_DEBUG}
                     ${xorg_xcb-render_COMPILE_OPTIONS_CXX_DEBUG}>)
set(xorg_xcb-render_TARGET_PROPERTIES TRUE)
########## COMPONENT xcb-randr TARGET PROPERTIES ######################################

set_property(TARGET xorg::xcb-randr PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${xorg_xcb-randr_LINK_LIBS_RELEASE} ${xorg_xcb-randr_LINKER_FLAGS_LIST_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xcb-randr_LINK_LIBS_RELWITHDEBINFO} ${xorg_xcb-randr_LINKER_FLAGS_LIST_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xcb-randr_LINK_LIBS_MINSIZEREL} ${xorg_xcb-randr_LINKER_FLAGS_LIST_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xcb-randr_LINK_LIBS_DEBUG} ${xorg_xcb-randr_LINKER_FLAGS_LIST_DEBUG}>)
set_property(TARGET xorg::xcb-randr PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${xorg_xcb-randr_INCLUDE_DIRS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xcb-randr_INCLUDE_DIRS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xcb-randr_INCLUDE_DIRS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xcb-randr_INCLUDE_DIRS_DEBUG}>)
set_property(TARGET xorg::xcb-randr PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${xorg_xcb-randr_COMPILE_DEFINITIONS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xcb-randr_COMPILE_DEFINITIONS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xcb-randr_COMPILE_DEFINITIONS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xcb-randr_COMPILE_DEFINITIONS_DEBUG}>)
set_property(TARGET xorg::xcb-randr PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:
                     ${xorg_xcb-randr_COMPILE_OPTIONS_C_RELEASE}
                     ${xorg_xcb-randr_COMPILE_OPTIONS_CXX_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:
                     ${xorg_xcb-randr_COMPILE_OPTIONS_C_RELWITHDEBINFO}
                     ${xorg_xcb-randr_COMPILE_OPTIONS_CXX_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:
                     ${xorg_xcb-randr_COMPILE_OPTIONS_C_MINSIZEREL}
                     ${xorg_xcb-randr_COMPILE_OPTIONS_CXX_MINSIZEREL}>
                 $<$<CONFIG:Debug>:
                     ${xorg_xcb-randr_COMPILE_OPTIONS_C_DEBUG}
                     ${xorg_xcb-randr_COMPILE_OPTIONS_CXX_DEBUG}>)
set(xorg_xcb-randr_TARGET_PROPERTIES TRUE)
########## COMPONENT xcb-keysyms TARGET PROPERTIES ######################################

set_property(TARGET xorg::xcb-keysyms PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${xorg_xcb-keysyms_LINK_LIBS_RELEASE} ${xorg_xcb-keysyms_LINKER_FLAGS_LIST_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xcb-keysyms_LINK_LIBS_RELWITHDEBINFO} ${xorg_xcb-keysyms_LINKER_FLAGS_LIST_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xcb-keysyms_LINK_LIBS_MINSIZEREL} ${xorg_xcb-keysyms_LINKER_FLAGS_LIST_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xcb-keysyms_LINK_LIBS_DEBUG} ${xorg_xcb-keysyms_LINKER_FLAGS_LIST_DEBUG}>)
set_property(TARGET xorg::xcb-keysyms PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${xorg_xcb-keysyms_INCLUDE_DIRS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xcb-keysyms_INCLUDE_DIRS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xcb-keysyms_INCLUDE_DIRS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xcb-keysyms_INCLUDE_DIRS_DEBUG}>)
set_property(TARGET xorg::xcb-keysyms PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${xorg_xcb-keysyms_COMPILE_DEFINITIONS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xcb-keysyms_COMPILE_DEFINITIONS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xcb-keysyms_COMPILE_DEFINITIONS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xcb-keysyms_COMPILE_DEFINITIONS_DEBUG}>)
set_property(TARGET xorg::xcb-keysyms PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:
                     ${xorg_xcb-keysyms_COMPILE_OPTIONS_C_RELEASE}
                     ${xorg_xcb-keysyms_COMPILE_OPTIONS_CXX_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:
                     ${xorg_xcb-keysyms_COMPILE_OPTIONS_C_RELWITHDEBINFO}
                     ${xorg_xcb-keysyms_COMPILE_OPTIONS_CXX_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:
                     ${xorg_xcb-keysyms_COMPILE_OPTIONS_C_MINSIZEREL}
                     ${xorg_xcb-keysyms_COMPILE_OPTIONS_CXX_MINSIZEREL}>
                 $<$<CONFIG:Debug>:
                     ${xorg_xcb-keysyms_COMPILE_OPTIONS_C_DEBUG}
                     ${xorg_xcb-keysyms_COMPILE_OPTIONS_CXX_DEBUG}>)
set(xorg_xcb-keysyms_TARGET_PROPERTIES TRUE)
########## COMPONENT xcb-image TARGET PROPERTIES ######################################

set_property(TARGET xorg::xcb-image PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${xorg_xcb-image_LINK_LIBS_RELEASE} ${xorg_xcb-image_LINKER_FLAGS_LIST_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xcb-image_LINK_LIBS_RELWITHDEBINFO} ${xorg_xcb-image_LINKER_FLAGS_LIST_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xcb-image_LINK_LIBS_MINSIZEREL} ${xorg_xcb-image_LINKER_FLAGS_LIST_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xcb-image_LINK_LIBS_DEBUG} ${xorg_xcb-image_LINKER_FLAGS_LIST_DEBUG}>)
set_property(TARGET xorg::xcb-image PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${xorg_xcb-image_INCLUDE_DIRS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xcb-image_INCLUDE_DIRS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xcb-image_INCLUDE_DIRS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xcb-image_INCLUDE_DIRS_DEBUG}>)
set_property(TARGET xorg::xcb-image PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${xorg_xcb-image_COMPILE_DEFINITIONS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xcb-image_COMPILE_DEFINITIONS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xcb-image_COMPILE_DEFINITIONS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xcb-image_COMPILE_DEFINITIONS_DEBUG}>)
set_property(TARGET xorg::xcb-image PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:
                     ${xorg_xcb-image_COMPILE_OPTIONS_C_RELEASE}
                     ${xorg_xcb-image_COMPILE_OPTIONS_CXX_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:
                     ${xorg_xcb-image_COMPILE_OPTIONS_C_RELWITHDEBINFO}
                     ${xorg_xcb-image_COMPILE_OPTIONS_CXX_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:
                     ${xorg_xcb-image_COMPILE_OPTIONS_C_MINSIZEREL}
                     ${xorg_xcb-image_COMPILE_OPTIONS_CXX_MINSIZEREL}>
                 $<$<CONFIG:Debug>:
                     ${xorg_xcb-image_COMPILE_OPTIONS_C_DEBUG}
                     ${xorg_xcb-image_COMPILE_OPTIONS_CXX_DEBUG}>)
set(xorg_xcb-image_TARGET_PROPERTIES TRUE)
########## COMPONENT xcb-icccm TARGET PROPERTIES ######################################

set_property(TARGET xorg::xcb-icccm PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${xorg_xcb-icccm_LINK_LIBS_RELEASE} ${xorg_xcb-icccm_LINKER_FLAGS_LIST_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xcb-icccm_LINK_LIBS_RELWITHDEBINFO} ${xorg_xcb-icccm_LINKER_FLAGS_LIST_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xcb-icccm_LINK_LIBS_MINSIZEREL} ${xorg_xcb-icccm_LINKER_FLAGS_LIST_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xcb-icccm_LINK_LIBS_DEBUG} ${xorg_xcb-icccm_LINKER_FLAGS_LIST_DEBUG}>)
set_property(TARGET xorg::xcb-icccm PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${xorg_xcb-icccm_INCLUDE_DIRS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xcb-icccm_INCLUDE_DIRS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xcb-icccm_INCLUDE_DIRS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xcb-icccm_INCLUDE_DIRS_DEBUG}>)
set_property(TARGET xorg::xcb-icccm PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${xorg_xcb-icccm_COMPILE_DEFINITIONS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xcb-icccm_COMPILE_DEFINITIONS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xcb-icccm_COMPILE_DEFINITIONS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xcb-icccm_COMPILE_DEFINITIONS_DEBUG}>)
set_property(TARGET xorg::xcb-icccm PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:
                     ${xorg_xcb-icccm_COMPILE_OPTIONS_C_RELEASE}
                     ${xorg_xcb-icccm_COMPILE_OPTIONS_CXX_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:
                     ${xorg_xcb-icccm_COMPILE_OPTIONS_C_RELWITHDEBINFO}
                     ${xorg_xcb-icccm_COMPILE_OPTIONS_CXX_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:
                     ${xorg_xcb-icccm_COMPILE_OPTIONS_C_MINSIZEREL}
                     ${xorg_xcb-icccm_COMPILE_OPTIONS_CXX_MINSIZEREL}>
                 $<$<CONFIG:Debug>:
                     ${xorg_xcb-icccm_COMPILE_OPTIONS_C_DEBUG}
                     ${xorg_xcb-icccm_COMPILE_OPTIONS_CXX_DEBUG}>)
set(xorg_xcb-icccm_TARGET_PROPERTIES TRUE)
########## COMPONENT xcb-xkb TARGET PROPERTIES ######################################

set_property(TARGET xorg::xcb-xkb PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${xorg_xcb-xkb_LINK_LIBS_RELEASE} ${xorg_xcb-xkb_LINKER_FLAGS_LIST_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xcb-xkb_LINK_LIBS_RELWITHDEBINFO} ${xorg_xcb-xkb_LINKER_FLAGS_LIST_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xcb-xkb_LINK_LIBS_MINSIZEREL} ${xorg_xcb-xkb_LINKER_FLAGS_LIST_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xcb-xkb_LINK_LIBS_DEBUG} ${xorg_xcb-xkb_LINKER_FLAGS_LIST_DEBUG}>)
set_property(TARGET xorg::xcb-xkb PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${xorg_xcb-xkb_INCLUDE_DIRS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xcb-xkb_INCLUDE_DIRS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xcb-xkb_INCLUDE_DIRS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xcb-xkb_INCLUDE_DIRS_DEBUG}>)
set_property(TARGET xorg::xcb-xkb PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${xorg_xcb-xkb_COMPILE_DEFINITIONS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xcb-xkb_COMPILE_DEFINITIONS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xcb-xkb_COMPILE_DEFINITIONS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xcb-xkb_COMPILE_DEFINITIONS_DEBUG}>)
set_property(TARGET xorg::xcb-xkb PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:
                     ${xorg_xcb-xkb_COMPILE_OPTIONS_C_RELEASE}
                     ${xorg_xcb-xkb_COMPILE_OPTIONS_CXX_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:
                     ${xorg_xcb-xkb_COMPILE_OPTIONS_C_RELWITHDEBINFO}
                     ${xorg_xcb-xkb_COMPILE_OPTIONS_CXX_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:
                     ${xorg_xcb-xkb_COMPILE_OPTIONS_C_MINSIZEREL}
                     ${xorg_xcb-xkb_COMPILE_OPTIONS_CXX_MINSIZEREL}>
                 $<$<CONFIG:Debug>:
                     ${xorg_xcb-xkb_COMPILE_OPTIONS_C_DEBUG}
                     ${xorg_xcb-xkb_COMPILE_OPTIONS_CXX_DEBUG}>)
set(xorg_xcb-xkb_TARGET_PROPERTIES TRUE)
########## COMPONENT xtrans TARGET PROPERTIES ######################################

set_property(TARGET xorg::xtrans PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${xorg_xtrans_LINK_LIBS_RELEASE} ${xorg_xtrans_LINKER_FLAGS_LIST_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xtrans_LINK_LIBS_RELWITHDEBINFO} ${xorg_xtrans_LINKER_FLAGS_LIST_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xtrans_LINK_LIBS_MINSIZEREL} ${xorg_xtrans_LINKER_FLAGS_LIST_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xtrans_LINK_LIBS_DEBUG} ${xorg_xtrans_LINKER_FLAGS_LIST_DEBUG}>)
set_property(TARGET xorg::xtrans PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${xorg_xtrans_INCLUDE_DIRS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xtrans_INCLUDE_DIRS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xtrans_INCLUDE_DIRS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xtrans_INCLUDE_DIRS_DEBUG}>)
set_property(TARGET xorg::xtrans PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${xorg_xtrans_COMPILE_DEFINITIONS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xtrans_COMPILE_DEFINITIONS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xtrans_COMPILE_DEFINITIONS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xtrans_COMPILE_DEFINITIONS_DEBUG}>)
set_property(TARGET xorg::xtrans PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:
                     ${xorg_xtrans_COMPILE_OPTIONS_C_RELEASE}
                     ${xorg_xtrans_COMPILE_OPTIONS_CXX_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:
                     ${xorg_xtrans_COMPILE_OPTIONS_C_RELWITHDEBINFO}
                     ${xorg_xtrans_COMPILE_OPTIONS_CXX_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:
                     ${xorg_xtrans_COMPILE_OPTIONS_C_MINSIZEREL}
                     ${xorg_xtrans_COMPILE_OPTIONS_CXX_MINSIZEREL}>
                 $<$<CONFIG:Debug>:
                     ${xorg_xtrans_COMPILE_OPTIONS_C_DEBUG}
                     ${xorg_xtrans_COMPILE_OPTIONS_CXX_DEBUG}>)
set(xorg_xtrans_TARGET_PROPERTIES TRUE)
########## COMPONENT xxf86vm TARGET PROPERTIES ######################################

set_property(TARGET xorg::xxf86vm PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${xorg_xxf86vm_LINK_LIBS_RELEASE} ${xorg_xxf86vm_LINKER_FLAGS_LIST_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xxf86vm_LINK_LIBS_RELWITHDEBINFO} ${xorg_xxf86vm_LINKER_FLAGS_LIST_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xxf86vm_LINK_LIBS_MINSIZEREL} ${xorg_xxf86vm_LINKER_FLAGS_LIST_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xxf86vm_LINK_LIBS_DEBUG} ${xorg_xxf86vm_LINKER_FLAGS_LIST_DEBUG}>)
set_property(TARGET xorg::xxf86vm PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${xorg_xxf86vm_INCLUDE_DIRS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xxf86vm_INCLUDE_DIRS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xxf86vm_INCLUDE_DIRS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xxf86vm_INCLUDE_DIRS_DEBUG}>)
set_property(TARGET xorg::xxf86vm PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${xorg_xxf86vm_COMPILE_DEFINITIONS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xxf86vm_COMPILE_DEFINITIONS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xxf86vm_COMPILE_DEFINITIONS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xxf86vm_COMPILE_DEFINITIONS_DEBUG}>)
set_property(TARGET xorg::xxf86vm PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:
                     ${xorg_xxf86vm_COMPILE_OPTIONS_C_RELEASE}
                     ${xorg_xxf86vm_COMPILE_OPTIONS_CXX_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:
                     ${xorg_xxf86vm_COMPILE_OPTIONS_C_RELWITHDEBINFO}
                     ${xorg_xxf86vm_COMPILE_OPTIONS_CXX_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:
                     ${xorg_xxf86vm_COMPILE_OPTIONS_C_MINSIZEREL}
                     ${xorg_xxf86vm_COMPILE_OPTIONS_CXX_MINSIZEREL}>
                 $<$<CONFIG:Debug>:
                     ${xorg_xxf86vm_COMPILE_OPTIONS_C_DEBUG}
                     ${xorg_xxf86vm_COMPILE_OPTIONS_CXX_DEBUG}>)
set(xorg_xxf86vm_TARGET_PROPERTIES TRUE)
########## COMPONENT xvmc TARGET PROPERTIES ######################################

set_property(TARGET xorg::xvmc PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${xorg_xvmc_LINK_LIBS_RELEASE} ${xorg_xvmc_LINKER_FLAGS_LIST_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xvmc_LINK_LIBS_RELWITHDEBINFO} ${xorg_xvmc_LINKER_FLAGS_LIST_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xvmc_LINK_LIBS_MINSIZEREL} ${xorg_xvmc_LINKER_FLAGS_LIST_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xvmc_LINK_LIBS_DEBUG} ${xorg_xvmc_LINKER_FLAGS_LIST_DEBUG}>)
set_property(TARGET xorg::xvmc PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${xorg_xvmc_INCLUDE_DIRS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xvmc_INCLUDE_DIRS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xvmc_INCLUDE_DIRS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xvmc_INCLUDE_DIRS_DEBUG}>)
set_property(TARGET xorg::xvmc PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${xorg_xvmc_COMPILE_DEFINITIONS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xvmc_COMPILE_DEFINITIONS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xvmc_COMPILE_DEFINITIONS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xvmc_COMPILE_DEFINITIONS_DEBUG}>)
set_property(TARGET xorg::xvmc PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:
                     ${xorg_xvmc_COMPILE_OPTIONS_C_RELEASE}
                     ${xorg_xvmc_COMPILE_OPTIONS_CXX_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:
                     ${xorg_xvmc_COMPILE_OPTIONS_C_RELWITHDEBINFO}
                     ${xorg_xvmc_COMPILE_OPTIONS_CXX_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:
                     ${xorg_xvmc_COMPILE_OPTIONS_C_MINSIZEREL}
                     ${xorg_xvmc_COMPILE_OPTIONS_CXX_MINSIZEREL}>
                 $<$<CONFIG:Debug>:
                     ${xorg_xvmc_COMPILE_OPTIONS_C_DEBUG}
                     ${xorg_xvmc_COMPILE_OPTIONS_CXX_DEBUG}>)
set(xorg_xvmc_TARGET_PROPERTIES TRUE)
########## COMPONENT xv TARGET PROPERTIES ######################################

set_property(TARGET xorg::xv PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${xorg_xv_LINK_LIBS_RELEASE} ${xorg_xv_LINKER_FLAGS_LIST_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xv_LINK_LIBS_RELWITHDEBINFO} ${xorg_xv_LINKER_FLAGS_LIST_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xv_LINK_LIBS_MINSIZEREL} ${xorg_xv_LINKER_FLAGS_LIST_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xv_LINK_LIBS_DEBUG} ${xorg_xv_LINKER_FLAGS_LIST_DEBUG}>)
set_property(TARGET xorg::xv PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${xorg_xv_INCLUDE_DIRS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xv_INCLUDE_DIRS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xv_INCLUDE_DIRS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xv_INCLUDE_DIRS_DEBUG}>)
set_property(TARGET xorg::xv PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${xorg_xv_COMPILE_DEFINITIONS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xv_COMPILE_DEFINITIONS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xv_COMPILE_DEFINITIONS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xv_COMPILE_DEFINITIONS_DEBUG}>)
set_property(TARGET xorg::xv PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:
                     ${xorg_xv_COMPILE_OPTIONS_C_RELEASE}
                     ${xorg_xv_COMPILE_OPTIONS_CXX_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:
                     ${xorg_xv_COMPILE_OPTIONS_C_RELWITHDEBINFO}
                     ${xorg_xv_COMPILE_OPTIONS_CXX_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:
                     ${xorg_xv_COMPILE_OPTIONS_C_MINSIZEREL}
                     ${xorg_xv_COMPILE_OPTIONS_CXX_MINSIZEREL}>
                 $<$<CONFIG:Debug>:
                     ${xorg_xv_COMPILE_OPTIONS_C_DEBUG}
                     ${xorg_xv_COMPILE_OPTIONS_CXX_DEBUG}>)
set(xorg_xv_TARGET_PROPERTIES TRUE)
########## COMPONENT xtst TARGET PROPERTIES ######################################

set_property(TARGET xorg::xtst PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${xorg_xtst_LINK_LIBS_RELEASE} ${xorg_xtst_LINKER_FLAGS_LIST_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xtst_LINK_LIBS_RELWITHDEBINFO} ${xorg_xtst_LINKER_FLAGS_LIST_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xtst_LINK_LIBS_MINSIZEREL} ${xorg_xtst_LINKER_FLAGS_LIST_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xtst_LINK_LIBS_DEBUG} ${xorg_xtst_LINKER_FLAGS_LIST_DEBUG}>)
set_property(TARGET xorg::xtst PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${xorg_xtst_INCLUDE_DIRS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xtst_INCLUDE_DIRS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xtst_INCLUDE_DIRS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xtst_INCLUDE_DIRS_DEBUG}>)
set_property(TARGET xorg::xtst PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${xorg_xtst_COMPILE_DEFINITIONS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xtst_COMPILE_DEFINITIONS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xtst_COMPILE_DEFINITIONS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xtst_COMPILE_DEFINITIONS_DEBUG}>)
set_property(TARGET xorg::xtst PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:
                     ${xorg_xtst_COMPILE_OPTIONS_C_RELEASE}
                     ${xorg_xtst_COMPILE_OPTIONS_CXX_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:
                     ${xorg_xtst_COMPILE_OPTIONS_C_RELWITHDEBINFO}
                     ${xorg_xtst_COMPILE_OPTIONS_CXX_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:
                     ${xorg_xtst_COMPILE_OPTIONS_C_MINSIZEREL}
                     ${xorg_xtst_COMPILE_OPTIONS_CXX_MINSIZEREL}>
                 $<$<CONFIG:Debug>:
                     ${xorg_xtst_COMPILE_OPTIONS_C_DEBUG}
                     ${xorg_xtst_COMPILE_OPTIONS_CXX_DEBUG}>)
set(xorg_xtst_TARGET_PROPERTIES TRUE)
########## COMPONENT xt TARGET PROPERTIES ######################################

set_property(TARGET xorg::xt PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${xorg_xt_LINK_LIBS_RELEASE} ${xorg_xt_LINKER_FLAGS_LIST_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xt_LINK_LIBS_RELWITHDEBINFO} ${xorg_xt_LINKER_FLAGS_LIST_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xt_LINK_LIBS_MINSIZEREL} ${xorg_xt_LINKER_FLAGS_LIST_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xt_LINK_LIBS_DEBUG} ${xorg_xt_LINKER_FLAGS_LIST_DEBUG}>)
set_property(TARGET xorg::xt PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${xorg_xt_INCLUDE_DIRS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xt_INCLUDE_DIRS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xt_INCLUDE_DIRS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xt_INCLUDE_DIRS_DEBUG}>)
set_property(TARGET xorg::xt PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${xorg_xt_COMPILE_DEFINITIONS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xt_COMPILE_DEFINITIONS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xt_COMPILE_DEFINITIONS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xt_COMPILE_DEFINITIONS_DEBUG}>)
set_property(TARGET xorg::xt PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:
                     ${xorg_xt_COMPILE_OPTIONS_C_RELEASE}
                     ${xorg_xt_COMPILE_OPTIONS_CXX_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:
                     ${xorg_xt_COMPILE_OPTIONS_C_RELWITHDEBINFO}
                     ${xorg_xt_COMPILE_OPTIONS_CXX_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:
                     ${xorg_xt_COMPILE_OPTIONS_C_MINSIZEREL}
                     ${xorg_xt_COMPILE_OPTIONS_CXX_MINSIZEREL}>
                 $<$<CONFIG:Debug>:
                     ${xorg_xt_COMPILE_OPTIONS_C_DEBUG}
                     ${xorg_xt_COMPILE_OPTIONS_CXX_DEBUG}>)
set(xorg_xt_TARGET_PROPERTIES TRUE)
########## COMPONENT xscrnsaver TARGET PROPERTIES ######################################

set_property(TARGET xorg::xscrnsaver PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${xorg_xscrnsaver_LINK_LIBS_RELEASE} ${xorg_xscrnsaver_LINKER_FLAGS_LIST_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xscrnsaver_LINK_LIBS_RELWITHDEBINFO} ${xorg_xscrnsaver_LINKER_FLAGS_LIST_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xscrnsaver_LINK_LIBS_MINSIZEREL} ${xorg_xscrnsaver_LINKER_FLAGS_LIST_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xscrnsaver_LINK_LIBS_DEBUG} ${xorg_xscrnsaver_LINKER_FLAGS_LIST_DEBUG}>)
set_property(TARGET xorg::xscrnsaver PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${xorg_xscrnsaver_INCLUDE_DIRS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xscrnsaver_INCLUDE_DIRS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xscrnsaver_INCLUDE_DIRS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xscrnsaver_INCLUDE_DIRS_DEBUG}>)
set_property(TARGET xorg::xscrnsaver PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${xorg_xscrnsaver_COMPILE_DEFINITIONS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xscrnsaver_COMPILE_DEFINITIONS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xscrnsaver_COMPILE_DEFINITIONS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xscrnsaver_COMPILE_DEFINITIONS_DEBUG}>)
set_property(TARGET xorg::xscrnsaver PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:
                     ${xorg_xscrnsaver_COMPILE_OPTIONS_C_RELEASE}
                     ${xorg_xscrnsaver_COMPILE_OPTIONS_CXX_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:
                     ${xorg_xscrnsaver_COMPILE_OPTIONS_C_RELWITHDEBINFO}
                     ${xorg_xscrnsaver_COMPILE_OPTIONS_CXX_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:
                     ${xorg_xscrnsaver_COMPILE_OPTIONS_C_MINSIZEREL}
                     ${xorg_xscrnsaver_COMPILE_OPTIONS_CXX_MINSIZEREL}>
                 $<$<CONFIG:Debug>:
                     ${xorg_xscrnsaver_COMPILE_OPTIONS_C_DEBUG}
                     ${xorg_xscrnsaver_COMPILE_OPTIONS_CXX_DEBUG}>)
set(xorg_xscrnsaver_TARGET_PROPERTIES TRUE)
########## COMPONENT xres TARGET PROPERTIES ######################################

set_property(TARGET xorg::xres PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${xorg_xres_LINK_LIBS_RELEASE} ${xorg_xres_LINKER_FLAGS_LIST_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xres_LINK_LIBS_RELWITHDEBINFO} ${xorg_xres_LINKER_FLAGS_LIST_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xres_LINK_LIBS_MINSIZEREL} ${xorg_xres_LINKER_FLAGS_LIST_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xres_LINK_LIBS_DEBUG} ${xorg_xres_LINKER_FLAGS_LIST_DEBUG}>)
set_property(TARGET xorg::xres PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${xorg_xres_INCLUDE_DIRS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xres_INCLUDE_DIRS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xres_INCLUDE_DIRS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xres_INCLUDE_DIRS_DEBUG}>)
set_property(TARGET xorg::xres PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${xorg_xres_COMPILE_DEFINITIONS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xres_COMPILE_DEFINITIONS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xres_COMPILE_DEFINITIONS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xres_COMPILE_DEFINITIONS_DEBUG}>)
set_property(TARGET xorg::xres PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:
                     ${xorg_xres_COMPILE_OPTIONS_C_RELEASE}
                     ${xorg_xres_COMPILE_OPTIONS_CXX_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:
                     ${xorg_xres_COMPILE_OPTIONS_C_RELWITHDEBINFO}
                     ${xorg_xres_COMPILE_OPTIONS_CXX_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:
                     ${xorg_xres_COMPILE_OPTIONS_C_MINSIZEREL}
                     ${xorg_xres_COMPILE_OPTIONS_CXX_MINSIZEREL}>
                 $<$<CONFIG:Debug>:
                     ${xorg_xres_COMPILE_OPTIONS_C_DEBUG}
                     ${xorg_xres_COMPILE_OPTIONS_CXX_DEBUG}>)
set(xorg_xres_TARGET_PROPERTIES TRUE)
########## COMPONENT xrender TARGET PROPERTIES ######################################

set_property(TARGET xorg::xrender PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${xorg_xrender_LINK_LIBS_RELEASE} ${xorg_xrender_LINKER_FLAGS_LIST_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xrender_LINK_LIBS_RELWITHDEBINFO} ${xorg_xrender_LINKER_FLAGS_LIST_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xrender_LINK_LIBS_MINSIZEREL} ${xorg_xrender_LINKER_FLAGS_LIST_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xrender_LINK_LIBS_DEBUG} ${xorg_xrender_LINKER_FLAGS_LIST_DEBUG}>)
set_property(TARGET xorg::xrender PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${xorg_xrender_INCLUDE_DIRS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xrender_INCLUDE_DIRS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xrender_INCLUDE_DIRS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xrender_INCLUDE_DIRS_DEBUG}>)
set_property(TARGET xorg::xrender PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${xorg_xrender_COMPILE_DEFINITIONS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xrender_COMPILE_DEFINITIONS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xrender_COMPILE_DEFINITIONS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xrender_COMPILE_DEFINITIONS_DEBUG}>)
set_property(TARGET xorg::xrender PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:
                     ${xorg_xrender_COMPILE_OPTIONS_C_RELEASE}
                     ${xorg_xrender_COMPILE_OPTIONS_CXX_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:
                     ${xorg_xrender_COMPILE_OPTIONS_C_RELWITHDEBINFO}
                     ${xorg_xrender_COMPILE_OPTIONS_CXX_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:
                     ${xorg_xrender_COMPILE_OPTIONS_C_MINSIZEREL}
                     ${xorg_xrender_COMPILE_OPTIONS_CXX_MINSIZEREL}>
                 $<$<CONFIG:Debug>:
                     ${xorg_xrender_COMPILE_OPTIONS_C_DEBUG}
                     ${xorg_xrender_COMPILE_OPTIONS_CXX_DEBUG}>)
set(xorg_xrender_TARGET_PROPERTIES TRUE)
########## COMPONENT xrandr TARGET PROPERTIES ######################################

set_property(TARGET xorg::xrandr PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${xorg_xrandr_LINK_LIBS_RELEASE} ${xorg_xrandr_LINKER_FLAGS_LIST_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xrandr_LINK_LIBS_RELWITHDEBINFO} ${xorg_xrandr_LINKER_FLAGS_LIST_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xrandr_LINK_LIBS_MINSIZEREL} ${xorg_xrandr_LINKER_FLAGS_LIST_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xrandr_LINK_LIBS_DEBUG} ${xorg_xrandr_LINKER_FLAGS_LIST_DEBUG}>)
set_property(TARGET xorg::xrandr PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${xorg_xrandr_INCLUDE_DIRS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xrandr_INCLUDE_DIRS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xrandr_INCLUDE_DIRS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xrandr_INCLUDE_DIRS_DEBUG}>)
set_property(TARGET xorg::xrandr PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${xorg_xrandr_COMPILE_DEFINITIONS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xrandr_COMPILE_DEFINITIONS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xrandr_COMPILE_DEFINITIONS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xrandr_COMPILE_DEFINITIONS_DEBUG}>)
set_property(TARGET xorg::xrandr PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:
                     ${xorg_xrandr_COMPILE_OPTIONS_C_RELEASE}
                     ${xorg_xrandr_COMPILE_OPTIONS_CXX_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:
                     ${xorg_xrandr_COMPILE_OPTIONS_C_RELWITHDEBINFO}
                     ${xorg_xrandr_COMPILE_OPTIONS_CXX_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:
                     ${xorg_xrandr_COMPILE_OPTIONS_C_MINSIZEREL}
                     ${xorg_xrandr_COMPILE_OPTIONS_CXX_MINSIZEREL}>
                 $<$<CONFIG:Debug>:
                     ${xorg_xrandr_COMPILE_OPTIONS_C_DEBUG}
                     ${xorg_xrandr_COMPILE_OPTIONS_CXX_DEBUG}>)
set(xorg_xrandr_TARGET_PROPERTIES TRUE)
########## COMPONENT xpm TARGET PROPERTIES ######################################

set_property(TARGET xorg::xpm PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${xorg_xpm_LINK_LIBS_RELEASE} ${xorg_xpm_LINKER_FLAGS_LIST_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xpm_LINK_LIBS_RELWITHDEBINFO} ${xorg_xpm_LINKER_FLAGS_LIST_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xpm_LINK_LIBS_MINSIZEREL} ${xorg_xpm_LINKER_FLAGS_LIST_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xpm_LINK_LIBS_DEBUG} ${xorg_xpm_LINKER_FLAGS_LIST_DEBUG}>)
set_property(TARGET xorg::xpm PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${xorg_xpm_INCLUDE_DIRS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xpm_INCLUDE_DIRS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xpm_INCLUDE_DIRS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xpm_INCLUDE_DIRS_DEBUG}>)
set_property(TARGET xorg::xpm PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${xorg_xpm_COMPILE_DEFINITIONS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xpm_COMPILE_DEFINITIONS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xpm_COMPILE_DEFINITIONS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xpm_COMPILE_DEFINITIONS_DEBUG}>)
set_property(TARGET xorg::xpm PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:
                     ${xorg_xpm_COMPILE_OPTIONS_C_RELEASE}
                     ${xorg_xpm_COMPILE_OPTIONS_CXX_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:
                     ${xorg_xpm_COMPILE_OPTIONS_C_RELWITHDEBINFO}
                     ${xorg_xpm_COMPILE_OPTIONS_CXX_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:
                     ${xorg_xpm_COMPILE_OPTIONS_C_MINSIZEREL}
                     ${xorg_xpm_COMPILE_OPTIONS_CXX_MINSIZEREL}>
                 $<$<CONFIG:Debug>:
                     ${xorg_xpm_COMPILE_OPTIONS_C_DEBUG}
                     ${xorg_xpm_COMPILE_OPTIONS_CXX_DEBUG}>)
set(xorg_xpm_TARGET_PROPERTIES TRUE)
########## COMPONENT xmuu TARGET PROPERTIES ######################################

set_property(TARGET xorg::xmuu PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${xorg_xmuu_LINK_LIBS_RELEASE} ${xorg_xmuu_LINKER_FLAGS_LIST_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xmuu_LINK_LIBS_RELWITHDEBINFO} ${xorg_xmuu_LINKER_FLAGS_LIST_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xmuu_LINK_LIBS_MINSIZEREL} ${xorg_xmuu_LINKER_FLAGS_LIST_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xmuu_LINK_LIBS_DEBUG} ${xorg_xmuu_LINKER_FLAGS_LIST_DEBUG}>)
set_property(TARGET xorg::xmuu PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${xorg_xmuu_INCLUDE_DIRS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xmuu_INCLUDE_DIRS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xmuu_INCLUDE_DIRS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xmuu_INCLUDE_DIRS_DEBUG}>)
set_property(TARGET xorg::xmuu PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${xorg_xmuu_COMPILE_DEFINITIONS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xmuu_COMPILE_DEFINITIONS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xmuu_COMPILE_DEFINITIONS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xmuu_COMPILE_DEFINITIONS_DEBUG}>)
set_property(TARGET xorg::xmuu PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:
                     ${xorg_xmuu_COMPILE_OPTIONS_C_RELEASE}
                     ${xorg_xmuu_COMPILE_OPTIONS_CXX_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:
                     ${xorg_xmuu_COMPILE_OPTIONS_C_RELWITHDEBINFO}
                     ${xorg_xmuu_COMPILE_OPTIONS_CXX_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:
                     ${xorg_xmuu_COMPILE_OPTIONS_C_MINSIZEREL}
                     ${xorg_xmuu_COMPILE_OPTIONS_CXX_MINSIZEREL}>
                 $<$<CONFIG:Debug>:
                     ${xorg_xmuu_COMPILE_OPTIONS_C_DEBUG}
                     ${xorg_xmuu_COMPILE_OPTIONS_CXX_DEBUG}>)
set(xorg_xmuu_TARGET_PROPERTIES TRUE)
########## COMPONENT xmu TARGET PROPERTIES ######################################

set_property(TARGET xorg::xmu PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${xorg_xmu_LINK_LIBS_RELEASE} ${xorg_xmu_LINKER_FLAGS_LIST_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xmu_LINK_LIBS_RELWITHDEBINFO} ${xorg_xmu_LINKER_FLAGS_LIST_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xmu_LINK_LIBS_MINSIZEREL} ${xorg_xmu_LINKER_FLAGS_LIST_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xmu_LINK_LIBS_DEBUG} ${xorg_xmu_LINKER_FLAGS_LIST_DEBUG}>)
set_property(TARGET xorg::xmu PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${xorg_xmu_INCLUDE_DIRS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xmu_INCLUDE_DIRS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xmu_INCLUDE_DIRS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xmu_INCLUDE_DIRS_DEBUG}>)
set_property(TARGET xorg::xmu PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${xorg_xmu_COMPILE_DEFINITIONS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xmu_COMPILE_DEFINITIONS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xmu_COMPILE_DEFINITIONS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xmu_COMPILE_DEFINITIONS_DEBUG}>)
set_property(TARGET xorg::xmu PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:
                     ${xorg_xmu_COMPILE_OPTIONS_C_RELEASE}
                     ${xorg_xmu_COMPILE_OPTIONS_CXX_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:
                     ${xorg_xmu_COMPILE_OPTIONS_C_RELWITHDEBINFO}
                     ${xorg_xmu_COMPILE_OPTIONS_CXX_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:
                     ${xorg_xmu_COMPILE_OPTIONS_C_MINSIZEREL}
                     ${xorg_xmu_COMPILE_OPTIONS_CXX_MINSIZEREL}>
                 $<$<CONFIG:Debug>:
                     ${xorg_xmu_COMPILE_OPTIONS_C_DEBUG}
                     ${xorg_xmu_COMPILE_OPTIONS_CXX_DEBUG}>)
set(xorg_xmu_TARGET_PROPERTIES TRUE)
########## COMPONENT xkbfile TARGET PROPERTIES ######################################

set_property(TARGET xorg::xkbfile PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${xorg_xkbfile_LINK_LIBS_RELEASE} ${xorg_xkbfile_LINKER_FLAGS_LIST_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xkbfile_LINK_LIBS_RELWITHDEBINFO} ${xorg_xkbfile_LINKER_FLAGS_LIST_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xkbfile_LINK_LIBS_MINSIZEREL} ${xorg_xkbfile_LINKER_FLAGS_LIST_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xkbfile_LINK_LIBS_DEBUG} ${xorg_xkbfile_LINKER_FLAGS_LIST_DEBUG}>)
set_property(TARGET xorg::xkbfile PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${xorg_xkbfile_INCLUDE_DIRS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xkbfile_INCLUDE_DIRS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xkbfile_INCLUDE_DIRS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xkbfile_INCLUDE_DIRS_DEBUG}>)
set_property(TARGET xorg::xkbfile PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${xorg_xkbfile_COMPILE_DEFINITIONS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xkbfile_COMPILE_DEFINITIONS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xkbfile_COMPILE_DEFINITIONS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xkbfile_COMPILE_DEFINITIONS_DEBUG}>)
set_property(TARGET xorg::xkbfile PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:
                     ${xorg_xkbfile_COMPILE_OPTIONS_C_RELEASE}
                     ${xorg_xkbfile_COMPILE_OPTIONS_CXX_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:
                     ${xorg_xkbfile_COMPILE_OPTIONS_C_RELWITHDEBINFO}
                     ${xorg_xkbfile_COMPILE_OPTIONS_CXX_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:
                     ${xorg_xkbfile_COMPILE_OPTIONS_C_MINSIZEREL}
                     ${xorg_xkbfile_COMPILE_OPTIONS_CXX_MINSIZEREL}>
                 $<$<CONFIG:Debug>:
                     ${xorg_xkbfile_COMPILE_OPTIONS_C_DEBUG}
                     ${xorg_xkbfile_COMPILE_OPTIONS_CXX_DEBUG}>)
set(xorg_xkbfile_TARGET_PROPERTIES TRUE)
########## COMPONENT xinerama TARGET PROPERTIES ######################################

set_property(TARGET xorg::xinerama PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${xorg_xinerama_LINK_LIBS_RELEASE} ${xorg_xinerama_LINKER_FLAGS_LIST_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xinerama_LINK_LIBS_RELWITHDEBINFO} ${xorg_xinerama_LINKER_FLAGS_LIST_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xinerama_LINK_LIBS_MINSIZEREL} ${xorg_xinerama_LINKER_FLAGS_LIST_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xinerama_LINK_LIBS_DEBUG} ${xorg_xinerama_LINKER_FLAGS_LIST_DEBUG}>)
set_property(TARGET xorg::xinerama PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${xorg_xinerama_INCLUDE_DIRS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xinerama_INCLUDE_DIRS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xinerama_INCLUDE_DIRS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xinerama_INCLUDE_DIRS_DEBUG}>)
set_property(TARGET xorg::xinerama PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${xorg_xinerama_COMPILE_DEFINITIONS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xinerama_COMPILE_DEFINITIONS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xinerama_COMPILE_DEFINITIONS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xinerama_COMPILE_DEFINITIONS_DEBUG}>)
set_property(TARGET xorg::xinerama PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:
                     ${xorg_xinerama_COMPILE_OPTIONS_C_RELEASE}
                     ${xorg_xinerama_COMPILE_OPTIONS_CXX_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:
                     ${xorg_xinerama_COMPILE_OPTIONS_C_RELWITHDEBINFO}
                     ${xorg_xinerama_COMPILE_OPTIONS_CXX_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:
                     ${xorg_xinerama_COMPILE_OPTIONS_C_MINSIZEREL}
                     ${xorg_xinerama_COMPILE_OPTIONS_CXX_MINSIZEREL}>
                 $<$<CONFIG:Debug>:
                     ${xorg_xinerama_COMPILE_OPTIONS_C_DEBUG}
                     ${xorg_xinerama_COMPILE_OPTIONS_CXX_DEBUG}>)
set(xorg_xinerama_TARGET_PROPERTIES TRUE)
########## COMPONENT xi TARGET PROPERTIES ######################################

set_property(TARGET xorg::xi PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${xorg_xi_LINK_LIBS_RELEASE} ${xorg_xi_LINKER_FLAGS_LIST_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xi_LINK_LIBS_RELWITHDEBINFO} ${xorg_xi_LINKER_FLAGS_LIST_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xi_LINK_LIBS_MINSIZEREL} ${xorg_xi_LINKER_FLAGS_LIST_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xi_LINK_LIBS_DEBUG} ${xorg_xi_LINKER_FLAGS_LIST_DEBUG}>)
set_property(TARGET xorg::xi PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${xorg_xi_INCLUDE_DIRS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xi_INCLUDE_DIRS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xi_INCLUDE_DIRS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xi_INCLUDE_DIRS_DEBUG}>)
set_property(TARGET xorg::xi PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${xorg_xi_COMPILE_DEFINITIONS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xi_COMPILE_DEFINITIONS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xi_COMPILE_DEFINITIONS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xi_COMPILE_DEFINITIONS_DEBUG}>)
set_property(TARGET xorg::xi PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:
                     ${xorg_xi_COMPILE_OPTIONS_C_RELEASE}
                     ${xorg_xi_COMPILE_OPTIONS_CXX_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:
                     ${xorg_xi_COMPILE_OPTIONS_C_RELWITHDEBINFO}
                     ${xorg_xi_COMPILE_OPTIONS_CXX_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:
                     ${xorg_xi_COMPILE_OPTIONS_C_MINSIZEREL}
                     ${xorg_xi_COMPILE_OPTIONS_CXX_MINSIZEREL}>
                 $<$<CONFIG:Debug>:
                     ${xorg_xi_COMPILE_OPTIONS_C_DEBUG}
                     ${xorg_xi_COMPILE_OPTIONS_CXX_DEBUG}>)
set(xorg_xi_TARGET_PROPERTIES TRUE)
########## COMPONENT xft TARGET PROPERTIES ######################################

set_property(TARGET xorg::xft PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${xorg_xft_LINK_LIBS_RELEASE} ${xorg_xft_LINKER_FLAGS_LIST_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xft_LINK_LIBS_RELWITHDEBINFO} ${xorg_xft_LINKER_FLAGS_LIST_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xft_LINK_LIBS_MINSIZEREL} ${xorg_xft_LINKER_FLAGS_LIST_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xft_LINK_LIBS_DEBUG} ${xorg_xft_LINKER_FLAGS_LIST_DEBUG}>)
set_property(TARGET xorg::xft PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${xorg_xft_INCLUDE_DIRS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xft_INCLUDE_DIRS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xft_INCLUDE_DIRS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xft_INCLUDE_DIRS_DEBUG}>)
set_property(TARGET xorg::xft PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${xorg_xft_COMPILE_DEFINITIONS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xft_COMPILE_DEFINITIONS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xft_COMPILE_DEFINITIONS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xft_COMPILE_DEFINITIONS_DEBUG}>)
set_property(TARGET xorg::xft PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:
                     ${xorg_xft_COMPILE_OPTIONS_C_RELEASE}
                     ${xorg_xft_COMPILE_OPTIONS_CXX_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:
                     ${xorg_xft_COMPILE_OPTIONS_C_RELWITHDEBINFO}
                     ${xorg_xft_COMPILE_OPTIONS_CXX_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:
                     ${xorg_xft_COMPILE_OPTIONS_C_MINSIZEREL}
                     ${xorg_xft_COMPILE_OPTIONS_CXX_MINSIZEREL}>
                 $<$<CONFIG:Debug>:
                     ${xorg_xft_COMPILE_OPTIONS_C_DEBUG}
                     ${xorg_xft_COMPILE_OPTIONS_CXX_DEBUG}>)
set(xorg_xft_TARGET_PROPERTIES TRUE)
########## COMPONENT xfixes TARGET PROPERTIES ######################################

set_property(TARGET xorg::xfixes PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${xorg_xfixes_LINK_LIBS_RELEASE} ${xorg_xfixes_LINKER_FLAGS_LIST_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xfixes_LINK_LIBS_RELWITHDEBINFO} ${xorg_xfixes_LINKER_FLAGS_LIST_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xfixes_LINK_LIBS_MINSIZEREL} ${xorg_xfixes_LINKER_FLAGS_LIST_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xfixes_LINK_LIBS_DEBUG} ${xorg_xfixes_LINKER_FLAGS_LIST_DEBUG}>)
set_property(TARGET xorg::xfixes PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${xorg_xfixes_INCLUDE_DIRS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xfixes_INCLUDE_DIRS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xfixes_INCLUDE_DIRS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xfixes_INCLUDE_DIRS_DEBUG}>)
set_property(TARGET xorg::xfixes PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${xorg_xfixes_COMPILE_DEFINITIONS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xfixes_COMPILE_DEFINITIONS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xfixes_COMPILE_DEFINITIONS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xfixes_COMPILE_DEFINITIONS_DEBUG}>)
set_property(TARGET xorg::xfixes PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:
                     ${xorg_xfixes_COMPILE_OPTIONS_C_RELEASE}
                     ${xorg_xfixes_COMPILE_OPTIONS_CXX_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:
                     ${xorg_xfixes_COMPILE_OPTIONS_C_RELWITHDEBINFO}
                     ${xorg_xfixes_COMPILE_OPTIONS_CXX_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:
                     ${xorg_xfixes_COMPILE_OPTIONS_C_MINSIZEREL}
                     ${xorg_xfixes_COMPILE_OPTIONS_CXX_MINSIZEREL}>
                 $<$<CONFIG:Debug>:
                     ${xorg_xfixes_COMPILE_OPTIONS_C_DEBUG}
                     ${xorg_xfixes_COMPILE_OPTIONS_CXX_DEBUG}>)
set(xorg_xfixes_TARGET_PROPERTIES TRUE)
########## COMPONENT xext TARGET PROPERTIES ######################################

set_property(TARGET xorg::xext PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${xorg_xext_LINK_LIBS_RELEASE} ${xorg_xext_LINKER_FLAGS_LIST_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xext_LINK_LIBS_RELWITHDEBINFO} ${xorg_xext_LINKER_FLAGS_LIST_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xext_LINK_LIBS_MINSIZEREL} ${xorg_xext_LINKER_FLAGS_LIST_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xext_LINK_LIBS_DEBUG} ${xorg_xext_LINKER_FLAGS_LIST_DEBUG}>)
set_property(TARGET xorg::xext PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${xorg_xext_INCLUDE_DIRS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xext_INCLUDE_DIRS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xext_INCLUDE_DIRS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xext_INCLUDE_DIRS_DEBUG}>)
set_property(TARGET xorg::xext PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${xorg_xext_COMPILE_DEFINITIONS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xext_COMPILE_DEFINITIONS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xext_COMPILE_DEFINITIONS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xext_COMPILE_DEFINITIONS_DEBUG}>)
set_property(TARGET xorg::xext PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:
                     ${xorg_xext_COMPILE_OPTIONS_C_RELEASE}
                     ${xorg_xext_COMPILE_OPTIONS_CXX_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:
                     ${xorg_xext_COMPILE_OPTIONS_C_RELWITHDEBINFO}
                     ${xorg_xext_COMPILE_OPTIONS_CXX_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:
                     ${xorg_xext_COMPILE_OPTIONS_C_MINSIZEREL}
                     ${xorg_xext_COMPILE_OPTIONS_CXX_MINSIZEREL}>
                 $<$<CONFIG:Debug>:
                     ${xorg_xext_COMPILE_OPTIONS_C_DEBUG}
                     ${xorg_xext_COMPILE_OPTIONS_CXX_DEBUG}>)
set(xorg_xext_TARGET_PROPERTIES TRUE)
########## COMPONENT xdmcp TARGET PROPERTIES ######################################

set_property(TARGET xorg::xdmcp PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${xorg_xdmcp_LINK_LIBS_RELEASE} ${xorg_xdmcp_LINKER_FLAGS_LIST_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xdmcp_LINK_LIBS_RELWITHDEBINFO} ${xorg_xdmcp_LINKER_FLAGS_LIST_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xdmcp_LINK_LIBS_MINSIZEREL} ${xorg_xdmcp_LINKER_FLAGS_LIST_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xdmcp_LINK_LIBS_DEBUG} ${xorg_xdmcp_LINKER_FLAGS_LIST_DEBUG}>)
set_property(TARGET xorg::xdmcp PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${xorg_xdmcp_INCLUDE_DIRS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xdmcp_INCLUDE_DIRS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xdmcp_INCLUDE_DIRS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xdmcp_INCLUDE_DIRS_DEBUG}>)
set_property(TARGET xorg::xdmcp PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${xorg_xdmcp_COMPILE_DEFINITIONS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xdmcp_COMPILE_DEFINITIONS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xdmcp_COMPILE_DEFINITIONS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xdmcp_COMPILE_DEFINITIONS_DEBUG}>)
set_property(TARGET xorg::xdmcp PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:
                     ${xorg_xdmcp_COMPILE_OPTIONS_C_RELEASE}
                     ${xorg_xdmcp_COMPILE_OPTIONS_CXX_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:
                     ${xorg_xdmcp_COMPILE_OPTIONS_C_RELWITHDEBINFO}
                     ${xorg_xdmcp_COMPILE_OPTIONS_CXX_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:
                     ${xorg_xdmcp_COMPILE_OPTIONS_C_MINSIZEREL}
                     ${xorg_xdmcp_COMPILE_OPTIONS_CXX_MINSIZEREL}>
                 $<$<CONFIG:Debug>:
                     ${xorg_xdmcp_COMPILE_OPTIONS_C_DEBUG}
                     ${xorg_xdmcp_COMPILE_OPTIONS_CXX_DEBUG}>)
set(xorg_xdmcp_TARGET_PROPERTIES TRUE)
########## COMPONENT xdamage TARGET PROPERTIES ######################################

set_property(TARGET xorg::xdamage PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${xorg_xdamage_LINK_LIBS_RELEASE} ${xorg_xdamage_LINKER_FLAGS_LIST_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xdamage_LINK_LIBS_RELWITHDEBINFO} ${xorg_xdamage_LINKER_FLAGS_LIST_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xdamage_LINK_LIBS_MINSIZEREL} ${xorg_xdamage_LINKER_FLAGS_LIST_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xdamage_LINK_LIBS_DEBUG} ${xorg_xdamage_LINKER_FLAGS_LIST_DEBUG}>)
set_property(TARGET xorg::xdamage PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${xorg_xdamage_INCLUDE_DIRS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xdamage_INCLUDE_DIRS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xdamage_INCLUDE_DIRS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xdamage_INCLUDE_DIRS_DEBUG}>)
set_property(TARGET xorg::xdamage PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${xorg_xdamage_COMPILE_DEFINITIONS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xdamage_COMPILE_DEFINITIONS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xdamage_COMPILE_DEFINITIONS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xdamage_COMPILE_DEFINITIONS_DEBUG}>)
set_property(TARGET xorg::xdamage PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:
                     ${xorg_xdamage_COMPILE_OPTIONS_C_RELEASE}
                     ${xorg_xdamage_COMPILE_OPTIONS_CXX_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:
                     ${xorg_xdamage_COMPILE_OPTIONS_C_RELWITHDEBINFO}
                     ${xorg_xdamage_COMPILE_OPTIONS_CXX_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:
                     ${xorg_xdamage_COMPILE_OPTIONS_C_MINSIZEREL}
                     ${xorg_xdamage_COMPILE_OPTIONS_CXX_MINSIZEREL}>
                 $<$<CONFIG:Debug>:
                     ${xorg_xdamage_COMPILE_OPTIONS_C_DEBUG}
                     ${xorg_xdamage_COMPILE_OPTIONS_CXX_DEBUG}>)
set(xorg_xdamage_TARGET_PROPERTIES TRUE)
########## COMPONENT xcursor TARGET PROPERTIES ######################################

set_property(TARGET xorg::xcursor PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${xorg_xcursor_LINK_LIBS_RELEASE} ${xorg_xcursor_LINKER_FLAGS_LIST_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xcursor_LINK_LIBS_RELWITHDEBINFO} ${xorg_xcursor_LINKER_FLAGS_LIST_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xcursor_LINK_LIBS_MINSIZEREL} ${xorg_xcursor_LINKER_FLAGS_LIST_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xcursor_LINK_LIBS_DEBUG} ${xorg_xcursor_LINKER_FLAGS_LIST_DEBUG}>)
set_property(TARGET xorg::xcursor PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${xorg_xcursor_INCLUDE_DIRS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xcursor_INCLUDE_DIRS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xcursor_INCLUDE_DIRS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xcursor_INCLUDE_DIRS_DEBUG}>)
set_property(TARGET xorg::xcursor PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${xorg_xcursor_COMPILE_DEFINITIONS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xcursor_COMPILE_DEFINITIONS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xcursor_COMPILE_DEFINITIONS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xcursor_COMPILE_DEFINITIONS_DEBUG}>)
set_property(TARGET xorg::xcursor PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:
                     ${xorg_xcursor_COMPILE_OPTIONS_C_RELEASE}
                     ${xorg_xcursor_COMPILE_OPTIONS_CXX_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:
                     ${xorg_xcursor_COMPILE_OPTIONS_C_RELWITHDEBINFO}
                     ${xorg_xcursor_COMPILE_OPTIONS_CXX_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:
                     ${xorg_xcursor_COMPILE_OPTIONS_C_MINSIZEREL}
                     ${xorg_xcursor_COMPILE_OPTIONS_CXX_MINSIZEREL}>
                 $<$<CONFIG:Debug>:
                     ${xorg_xcursor_COMPILE_OPTIONS_C_DEBUG}
                     ${xorg_xcursor_COMPILE_OPTIONS_CXX_DEBUG}>)
set(xorg_xcursor_TARGET_PROPERTIES TRUE)
########## COMPONENT xcomposite TARGET PROPERTIES ######################################

set_property(TARGET xorg::xcomposite PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${xorg_xcomposite_LINK_LIBS_RELEASE} ${xorg_xcomposite_LINKER_FLAGS_LIST_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xcomposite_LINK_LIBS_RELWITHDEBINFO} ${xorg_xcomposite_LINKER_FLAGS_LIST_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xcomposite_LINK_LIBS_MINSIZEREL} ${xorg_xcomposite_LINKER_FLAGS_LIST_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xcomposite_LINK_LIBS_DEBUG} ${xorg_xcomposite_LINKER_FLAGS_LIST_DEBUG}>)
set_property(TARGET xorg::xcomposite PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${xorg_xcomposite_INCLUDE_DIRS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xcomposite_INCLUDE_DIRS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xcomposite_INCLUDE_DIRS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xcomposite_INCLUDE_DIRS_DEBUG}>)
set_property(TARGET xorg::xcomposite PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${xorg_xcomposite_COMPILE_DEFINITIONS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xcomposite_COMPILE_DEFINITIONS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xcomposite_COMPILE_DEFINITIONS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xcomposite_COMPILE_DEFINITIONS_DEBUG}>)
set_property(TARGET xorg::xcomposite PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:
                     ${xorg_xcomposite_COMPILE_OPTIONS_C_RELEASE}
                     ${xorg_xcomposite_COMPILE_OPTIONS_CXX_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:
                     ${xorg_xcomposite_COMPILE_OPTIONS_C_RELWITHDEBINFO}
                     ${xorg_xcomposite_COMPILE_OPTIONS_CXX_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:
                     ${xorg_xcomposite_COMPILE_OPTIONS_C_MINSIZEREL}
                     ${xorg_xcomposite_COMPILE_OPTIONS_CXX_MINSIZEREL}>
                 $<$<CONFIG:Debug>:
                     ${xorg_xcomposite_COMPILE_OPTIONS_C_DEBUG}
                     ${xorg_xcomposite_COMPILE_OPTIONS_CXX_DEBUG}>)
set(xorg_xcomposite_TARGET_PROPERTIES TRUE)
########## COMPONENT xaw7 TARGET PROPERTIES ######################################

set_property(TARGET xorg::xaw7 PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${xorg_xaw7_LINK_LIBS_RELEASE} ${xorg_xaw7_LINKER_FLAGS_LIST_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xaw7_LINK_LIBS_RELWITHDEBINFO} ${xorg_xaw7_LINKER_FLAGS_LIST_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xaw7_LINK_LIBS_MINSIZEREL} ${xorg_xaw7_LINKER_FLAGS_LIST_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xaw7_LINK_LIBS_DEBUG} ${xorg_xaw7_LINKER_FLAGS_LIST_DEBUG}>)
set_property(TARGET xorg::xaw7 PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${xorg_xaw7_INCLUDE_DIRS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xaw7_INCLUDE_DIRS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xaw7_INCLUDE_DIRS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xaw7_INCLUDE_DIRS_DEBUG}>)
set_property(TARGET xorg::xaw7 PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${xorg_xaw7_COMPILE_DEFINITIONS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xaw7_COMPILE_DEFINITIONS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xaw7_COMPILE_DEFINITIONS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xaw7_COMPILE_DEFINITIONS_DEBUG}>)
set_property(TARGET xorg::xaw7 PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:
                     ${xorg_xaw7_COMPILE_OPTIONS_C_RELEASE}
                     ${xorg_xaw7_COMPILE_OPTIONS_CXX_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:
                     ${xorg_xaw7_COMPILE_OPTIONS_C_RELWITHDEBINFO}
                     ${xorg_xaw7_COMPILE_OPTIONS_CXX_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:
                     ${xorg_xaw7_COMPILE_OPTIONS_C_MINSIZEREL}
                     ${xorg_xaw7_COMPILE_OPTIONS_CXX_MINSIZEREL}>
                 $<$<CONFIG:Debug>:
                     ${xorg_xaw7_COMPILE_OPTIONS_C_DEBUG}
                     ${xorg_xaw7_COMPILE_OPTIONS_CXX_DEBUG}>)
set(xorg_xaw7_TARGET_PROPERTIES TRUE)
########## COMPONENT xau TARGET PROPERTIES ######################################

set_property(TARGET xorg::xau PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${xorg_xau_LINK_LIBS_RELEASE} ${xorg_xau_LINKER_FLAGS_LIST_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xau_LINK_LIBS_RELWITHDEBINFO} ${xorg_xau_LINKER_FLAGS_LIST_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xau_LINK_LIBS_MINSIZEREL} ${xorg_xau_LINKER_FLAGS_LIST_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xau_LINK_LIBS_DEBUG} ${xorg_xau_LINKER_FLAGS_LIST_DEBUG}>)
set_property(TARGET xorg::xau PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${xorg_xau_INCLUDE_DIRS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xau_INCLUDE_DIRS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xau_INCLUDE_DIRS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xau_INCLUDE_DIRS_DEBUG}>)
set_property(TARGET xorg::xau PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${xorg_xau_COMPILE_DEFINITIONS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_xau_COMPILE_DEFINITIONS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_xau_COMPILE_DEFINITIONS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_xau_COMPILE_DEFINITIONS_DEBUG}>)
set_property(TARGET xorg::xau PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:
                     ${xorg_xau_COMPILE_OPTIONS_C_RELEASE}
                     ${xorg_xau_COMPILE_OPTIONS_CXX_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:
                     ${xorg_xau_COMPILE_OPTIONS_C_RELWITHDEBINFO}
                     ${xorg_xau_COMPILE_OPTIONS_CXX_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:
                     ${xorg_xau_COMPILE_OPTIONS_C_MINSIZEREL}
                     ${xorg_xau_COMPILE_OPTIONS_CXX_MINSIZEREL}>
                 $<$<CONFIG:Debug>:
                     ${xorg_xau_COMPILE_OPTIONS_C_DEBUG}
                     ${xorg_xau_COMPILE_OPTIONS_CXX_DEBUG}>)
set(xorg_xau_TARGET_PROPERTIES TRUE)
########## COMPONENT sm TARGET PROPERTIES ######################################

set_property(TARGET xorg::sm PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${xorg_sm_LINK_LIBS_RELEASE} ${xorg_sm_LINKER_FLAGS_LIST_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_sm_LINK_LIBS_RELWITHDEBINFO} ${xorg_sm_LINKER_FLAGS_LIST_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_sm_LINK_LIBS_MINSIZEREL} ${xorg_sm_LINKER_FLAGS_LIST_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_sm_LINK_LIBS_DEBUG} ${xorg_sm_LINKER_FLAGS_LIST_DEBUG}>)
set_property(TARGET xorg::sm PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${xorg_sm_INCLUDE_DIRS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_sm_INCLUDE_DIRS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_sm_INCLUDE_DIRS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_sm_INCLUDE_DIRS_DEBUG}>)
set_property(TARGET xorg::sm PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${xorg_sm_COMPILE_DEFINITIONS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_sm_COMPILE_DEFINITIONS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_sm_COMPILE_DEFINITIONS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_sm_COMPILE_DEFINITIONS_DEBUG}>)
set_property(TARGET xorg::sm PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:
                     ${xorg_sm_COMPILE_OPTIONS_C_RELEASE}
                     ${xorg_sm_COMPILE_OPTIONS_CXX_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:
                     ${xorg_sm_COMPILE_OPTIONS_C_RELWITHDEBINFO}
                     ${xorg_sm_COMPILE_OPTIONS_CXX_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:
                     ${xorg_sm_COMPILE_OPTIONS_C_MINSIZEREL}
                     ${xorg_sm_COMPILE_OPTIONS_CXX_MINSIZEREL}>
                 $<$<CONFIG:Debug>:
                     ${xorg_sm_COMPILE_OPTIONS_C_DEBUG}
                     ${xorg_sm_COMPILE_OPTIONS_CXX_DEBUG}>)
set(xorg_sm_TARGET_PROPERTIES TRUE)
########## COMPONENT ice TARGET PROPERTIES ######################################

set_property(TARGET xorg::ice PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${xorg_ice_LINK_LIBS_RELEASE} ${xorg_ice_LINKER_FLAGS_LIST_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_ice_LINK_LIBS_RELWITHDEBINFO} ${xorg_ice_LINKER_FLAGS_LIST_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_ice_LINK_LIBS_MINSIZEREL} ${xorg_ice_LINKER_FLAGS_LIST_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_ice_LINK_LIBS_DEBUG} ${xorg_ice_LINKER_FLAGS_LIST_DEBUG}>)
set_property(TARGET xorg::ice PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${xorg_ice_INCLUDE_DIRS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_ice_INCLUDE_DIRS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_ice_INCLUDE_DIRS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_ice_INCLUDE_DIRS_DEBUG}>)
set_property(TARGET xorg::ice PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${xorg_ice_COMPILE_DEFINITIONS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_ice_COMPILE_DEFINITIONS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_ice_COMPILE_DEFINITIONS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_ice_COMPILE_DEFINITIONS_DEBUG}>)
set_property(TARGET xorg::ice PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:
                     ${xorg_ice_COMPILE_OPTIONS_C_RELEASE}
                     ${xorg_ice_COMPILE_OPTIONS_CXX_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:
                     ${xorg_ice_COMPILE_OPTIONS_C_RELWITHDEBINFO}
                     ${xorg_ice_COMPILE_OPTIONS_CXX_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:
                     ${xorg_ice_COMPILE_OPTIONS_C_MINSIZEREL}
                     ${xorg_ice_COMPILE_OPTIONS_CXX_MINSIZEREL}>
                 $<$<CONFIG:Debug>:
                     ${xorg_ice_COMPILE_OPTIONS_C_DEBUG}
                     ${xorg_ice_COMPILE_OPTIONS_CXX_DEBUG}>)
set(xorg_ice_TARGET_PROPERTIES TRUE)
########## COMPONENT fontenc TARGET PROPERTIES ######################################

set_property(TARGET xorg::fontenc PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${xorg_fontenc_LINK_LIBS_RELEASE} ${xorg_fontenc_LINKER_FLAGS_LIST_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_fontenc_LINK_LIBS_RELWITHDEBINFO} ${xorg_fontenc_LINKER_FLAGS_LIST_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_fontenc_LINK_LIBS_MINSIZEREL} ${xorg_fontenc_LINKER_FLAGS_LIST_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_fontenc_LINK_LIBS_DEBUG} ${xorg_fontenc_LINKER_FLAGS_LIST_DEBUG}>)
set_property(TARGET xorg::fontenc PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${xorg_fontenc_INCLUDE_DIRS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_fontenc_INCLUDE_DIRS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_fontenc_INCLUDE_DIRS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_fontenc_INCLUDE_DIRS_DEBUG}>)
set_property(TARGET xorg::fontenc PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${xorg_fontenc_COMPILE_DEFINITIONS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_fontenc_COMPILE_DEFINITIONS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_fontenc_COMPILE_DEFINITIONS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_fontenc_COMPILE_DEFINITIONS_DEBUG}>)
set_property(TARGET xorg::fontenc PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:
                     ${xorg_fontenc_COMPILE_OPTIONS_C_RELEASE}
                     ${xorg_fontenc_COMPILE_OPTIONS_CXX_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:
                     ${xorg_fontenc_COMPILE_OPTIONS_C_RELWITHDEBINFO}
                     ${xorg_fontenc_COMPILE_OPTIONS_CXX_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:
                     ${xorg_fontenc_COMPILE_OPTIONS_C_MINSIZEREL}
                     ${xorg_fontenc_COMPILE_OPTIONS_CXX_MINSIZEREL}>
                 $<$<CONFIG:Debug>:
                     ${xorg_fontenc_COMPILE_OPTIONS_C_DEBUG}
                     ${xorg_fontenc_COMPILE_OPTIONS_CXX_DEBUG}>)
set(xorg_fontenc_TARGET_PROPERTIES TRUE)
########## COMPONENT x11-xcb TARGET PROPERTIES ######################################

set_property(TARGET xorg::x11-xcb PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${xorg_x11-xcb_LINK_LIBS_RELEASE} ${xorg_x11-xcb_LINKER_FLAGS_LIST_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_x11-xcb_LINK_LIBS_RELWITHDEBINFO} ${xorg_x11-xcb_LINKER_FLAGS_LIST_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_x11-xcb_LINK_LIBS_MINSIZEREL} ${xorg_x11-xcb_LINKER_FLAGS_LIST_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_x11-xcb_LINK_LIBS_DEBUG} ${xorg_x11-xcb_LINKER_FLAGS_LIST_DEBUG}>)
set_property(TARGET xorg::x11-xcb PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${xorg_x11-xcb_INCLUDE_DIRS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_x11-xcb_INCLUDE_DIRS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_x11-xcb_INCLUDE_DIRS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_x11-xcb_INCLUDE_DIRS_DEBUG}>)
set_property(TARGET xorg::x11-xcb PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${xorg_x11-xcb_COMPILE_DEFINITIONS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_x11-xcb_COMPILE_DEFINITIONS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_x11-xcb_COMPILE_DEFINITIONS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_x11-xcb_COMPILE_DEFINITIONS_DEBUG}>)
set_property(TARGET xorg::x11-xcb PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:
                     ${xorg_x11-xcb_COMPILE_OPTIONS_C_RELEASE}
                     ${xorg_x11-xcb_COMPILE_OPTIONS_CXX_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:
                     ${xorg_x11-xcb_COMPILE_OPTIONS_C_RELWITHDEBINFO}
                     ${xorg_x11-xcb_COMPILE_OPTIONS_CXX_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:
                     ${xorg_x11-xcb_COMPILE_OPTIONS_C_MINSIZEREL}
                     ${xorg_x11-xcb_COMPILE_OPTIONS_CXX_MINSIZEREL}>
                 $<$<CONFIG:Debug>:
                     ${xorg_x11-xcb_COMPILE_OPTIONS_C_DEBUG}
                     ${xorg_x11-xcb_COMPILE_OPTIONS_CXX_DEBUG}>)
set(xorg_x11-xcb_TARGET_PROPERTIES TRUE)
########## COMPONENT x11 TARGET PROPERTIES ######################################

set_property(TARGET xorg::x11 PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${xorg_x11_LINK_LIBS_RELEASE} ${xorg_x11_LINKER_FLAGS_LIST_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_x11_LINK_LIBS_RELWITHDEBINFO} ${xorg_x11_LINKER_FLAGS_LIST_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_x11_LINK_LIBS_MINSIZEREL} ${xorg_x11_LINKER_FLAGS_LIST_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_x11_LINK_LIBS_DEBUG} ${xorg_x11_LINKER_FLAGS_LIST_DEBUG}>)
set_property(TARGET xorg::x11 PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${xorg_x11_INCLUDE_DIRS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_x11_INCLUDE_DIRS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_x11_INCLUDE_DIRS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_x11_INCLUDE_DIRS_DEBUG}>)
set_property(TARGET xorg::x11 PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${xorg_x11_COMPILE_DEFINITIONS_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:${xorg_x11_COMPILE_DEFINITIONS_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:${xorg_x11_COMPILE_DEFINITIONS_MINSIZEREL}>
                 $<$<CONFIG:Debug>:${xorg_x11_COMPILE_DEFINITIONS_DEBUG}>)
set_property(TARGET xorg::x11 PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:
                     ${xorg_x11_COMPILE_OPTIONS_C_RELEASE}
                     ${xorg_x11_COMPILE_OPTIONS_CXX_RELEASE}>
                 $<$<CONFIG:RelWithDebInfo>:
                     ${xorg_x11_COMPILE_OPTIONS_C_RELWITHDEBINFO}
                     ${xorg_x11_COMPILE_OPTIONS_CXX_RELWITHDEBINFO}>
                 $<$<CONFIG:MinSizeRel>:
                     ${xorg_x11_COMPILE_OPTIONS_C_MINSIZEREL}
                     ${xorg_x11_COMPILE_OPTIONS_CXX_MINSIZEREL}>
                 $<$<CONFIG:Debug>:
                     ${xorg_x11_COMPILE_OPTIONS_C_DEBUG}
                     ${xorg_x11_COMPILE_OPTIONS_CXX_DEBUG}>)
set(xorg_x11_TARGET_PROPERTIES TRUE)

########## GLOBAL TARGET PROPERTIES #########################################################

if(NOT xorg_xorg_TARGET_PROPERTIES)
    set_property(TARGET xorg::xorg PROPERTY INTERFACE_LINK_LIBRARIES
                     $<$<CONFIG:Release>:${xorg_COMPONENTS_RELEASE}>
                     $<$<CONFIG:RelWithDebInfo>:${xorg_COMPONENTS_RELWITHDEBINFO}>
                     $<$<CONFIG:MinSizeRel>:${xorg_COMPONENTS_MINSIZEREL}>
                     $<$<CONFIG:Debug>:${xorg_COMPONENTS_DEBUG}>)
endif()