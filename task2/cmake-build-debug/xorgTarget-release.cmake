########## MACROS ###########################################################################
#############################################################################################


macro(conan_find_apple_frameworks FRAMEWORKS_FOUND FRAMEWORKS FRAMEWORKS_DIRS)
    if(APPLE)
        foreach(_FRAMEWORK ${FRAMEWORKS})
            # https://cmake.org/pipermail/cmake-developers/2017-August/030199.html
            find_library(CONAN_FRAMEWORK_${_FRAMEWORK}_FOUND NAME ${_FRAMEWORK} PATHS ${FRAMEWORKS_DIRS} CMAKE_FIND_ROOT_PATH_BOTH)
            if(CONAN_FRAMEWORK_${_FRAMEWORK}_FOUND)
                list(APPEND ${FRAMEWORKS_FOUND} ${CONAN_FRAMEWORK_${_FRAMEWORK}_FOUND})
            else()
                message(FATAL_ERROR "Framework library ${_FRAMEWORK} not found in paths: ${FRAMEWORKS_DIRS}")
            endif()
        endforeach()
    endif()
endmacro()


function(conan_package_library_targets libraries package_libdir deps out_libraries out_libraries_target build_type package_name)
    unset(_CONAN_ACTUAL_TARGETS CACHE)
    unset(_CONAN_FOUND_SYSTEM_LIBS CACHE)
    foreach(_LIBRARY_NAME ${libraries})
        find_library(CONAN_FOUND_LIBRARY NAME ${_LIBRARY_NAME} PATHS ${package_libdir}
                     NO_DEFAULT_PATH NO_CMAKE_FIND_ROOT_PATH)
        if(CONAN_FOUND_LIBRARY)
            conan_message(STATUS "Library ${_LIBRARY_NAME} found ${CONAN_FOUND_LIBRARY}")
            list(APPEND _out_libraries ${CONAN_FOUND_LIBRARY})
            if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
                # Create a micro-target for each lib/a found
                set(_LIB_NAME CONAN_LIB::${package_name}_${_LIBRARY_NAME}${build_type})
                if(NOT TARGET ${_LIB_NAME})
                    # Create a micro-target for each lib/a found
                    add_library(${_LIB_NAME} UNKNOWN IMPORTED)
                    set_target_properties(${_LIB_NAME} PROPERTIES IMPORTED_LOCATION ${CONAN_FOUND_LIBRARY})
                    set(_CONAN_ACTUAL_TARGETS ${_CONAN_ACTUAL_TARGETS} ${_LIB_NAME})
                else()
                    conan_message(STATUS "Skipping already existing target: ${_LIB_NAME}")
                endif()
                list(APPEND _out_libraries_target ${_LIB_NAME})
            endif()
            conan_message(STATUS "Found: ${CONAN_FOUND_LIBRARY}")
        else()
            conan_message(STATUS "Library ${_LIBRARY_NAME} not found in package, might be system one")
            list(APPEND _out_libraries_target ${_LIBRARY_NAME})
            list(APPEND _out_libraries ${_LIBRARY_NAME})
            set(_CONAN_FOUND_SYSTEM_LIBS "${_CONAN_FOUND_SYSTEM_LIBS};${_LIBRARY_NAME}")
        endif()
        unset(CONAN_FOUND_LIBRARY CACHE)
    endforeach()

    if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
        # Add all dependencies to all targets
        string(REPLACE " " ";" deps_list "${deps}")
        foreach(_CONAN_ACTUAL_TARGET ${_CONAN_ACTUAL_TARGETS})
            set_property(TARGET ${_CONAN_ACTUAL_TARGET} PROPERTY INTERFACE_LINK_LIBRARIES "${_CONAN_FOUND_SYSTEM_LIBS};${deps_list}")
        endforeach()
    endif()

    set(${out_libraries} ${_out_libraries} PARENT_SCOPE)
    set(${out_libraries_target} ${_out_libraries_target} PARENT_SCOPE)
endfunction()


########### VARIABLES #######################################################################
#############################################################################################


set(xorg_INCLUDE_DIRS_RELEASE "/usr/include/uuid"
			"/usr/include/freetype2"
			"/usr/include/libpng16")
set(xorg_INCLUDE_DIR_RELEASE "/usr/include/uuid;/usr/include/freetype2;/usr/include/libpng16")
set(xorg_INCLUDES_RELEASE "/usr/include/uuid"
			"/usr/include/freetype2"
			"/usr/include/libpng16")
set(xorg_RES_DIRS_RELEASE )
set(xorg_DEFINITIONS_RELEASE "-D_DEFAULT_SOURCE"
			"-D_BSD_SOURCE"
			"-DHAS_FCHOWN"
			"-DHAS_STICKY_DIR_BIT")
set(xorg_LINKER_FLAGS_RELEASE_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)
set(xorg_COMPILE_DEFINITIONS_RELEASE "_DEFAULT_SOURCE"
			"_BSD_SOURCE"
			"HAS_FCHOWN"
			"HAS_STICKY_DIR_BIT")
set(xorg_COMPILE_OPTIONS_RELEASE_LIST "" "")
set(xorg_COMPILE_OPTIONS_C_RELEASE "")
set(xorg_COMPILE_OPTIONS_CXX_RELEASE "")
set(xorg_LIBRARIES_TARGETS_RELEASE "") # Will be filled later, if CMake 3
set(xorg_LIBRARIES_RELEASE "") # Will be filled later
set(xorg_LIBS_RELEASE "") # Same as xorg_LIBRARIES
set(xorg_SYSTEM_LIBS_RELEASE X11 X11-xcb xcb fontenc ICE SM Xau Xaw7 Xt Xcomposite Xcursor Xdamage Xfixes Xdmcp Xext Xft Xi Xinerama xkbfile Xmu Xmuu Xpm Xrandr Xrender XRes Xss Xtst Xv XvMC Xxf86vm xcb-xkb xcb-icccm xcb-image xcb-shm xcb-keysyms xcb-randr xcb-render xcb-render-util xcb-shape xcb-sync xcb-xfixes xcb-xinerama)
set(xorg_FRAMEWORK_DIRS_RELEASE )
set(xorg_FRAMEWORKS_RELEASE )
set(xorg_FRAMEWORKS_FOUND_RELEASE "") # Will be filled later
set(xorg_BUILD_MODULES_PATHS_RELEASE )

conan_find_apple_frameworks(xorg_FRAMEWORKS_FOUND_RELEASE "${xorg_FRAMEWORKS_RELEASE}" "${xorg_FRAMEWORK_DIRS_RELEASE}")

mark_as_advanced(xorg_INCLUDE_DIRS_RELEASE
                 xorg_INCLUDE_DIR_RELEASE
                 xorg_INCLUDES_RELEASE
                 xorg_DEFINITIONS_RELEASE
                 xorg_LINKER_FLAGS_RELEASE_LIST
                 xorg_COMPILE_DEFINITIONS_RELEASE
                 xorg_COMPILE_OPTIONS_RELEASE_LIST
                 xorg_LIBRARIES_RELEASE
                 xorg_LIBS_RELEASE
                 xorg_LIBRARIES_TARGETS_RELEASE)

# Find the real .lib/.a and add them to xorg_LIBS and xorg_LIBRARY_LIST
set(xorg_LIBRARY_LIST_RELEASE )
set(xorg_LIB_DIRS_RELEASE )

# Gather all the libraries that should be linked to the targets (do not touch existing variables):
set(_xorg_DEPENDENCIES_RELEASE "${xorg_FRAMEWORKS_FOUND_RELEASE} ${xorg_SYSTEM_LIBS_RELEASE} ")

conan_package_library_targets("${xorg_LIBRARY_LIST_RELEASE}"  # libraries
                              "${xorg_LIB_DIRS_RELEASE}"      # package_libdir
                              "${_xorg_DEPENDENCIES_RELEASE}"  # deps
                              xorg_LIBRARIES_RELEASE            # out_libraries
                              xorg_LIBRARIES_TARGETS_RELEASE    # out_libraries_targets
                              "_RELEASE"                          # build_type
                              "xorg")                                      # package_name

set(xorg_LIBS_RELEASE ${xorg_LIBRARIES_RELEASE})

foreach(_FRAMEWORK ${xorg_FRAMEWORKS_FOUND_RELEASE})
    list(APPEND xorg_LIBRARIES_TARGETS_RELEASE ${_FRAMEWORK})
    list(APPEND xorg_LIBRARIES_RELEASE ${_FRAMEWORK})
endforeach()

foreach(_SYSTEM_LIB ${xorg_SYSTEM_LIBS_RELEASE})
    list(APPEND xorg_LIBRARIES_TARGETS_RELEASE ${_SYSTEM_LIB})
    list(APPEND xorg_LIBRARIES_RELEASE ${_SYSTEM_LIB})
endforeach()

# We need to add our requirements too
set(xorg_LIBRARIES_TARGETS_RELEASE "${xorg_LIBRARIES_TARGETS_RELEASE};")
set(xorg_LIBRARIES_RELEASE "${xorg_LIBRARIES_RELEASE};")

set(CMAKE_MODULE_PATH "/home/smirnov-i/.conan/data/xorg/system/_/_/package/5ab84d6acfe1f23c4fae0ab88f26e3a396351ac9/" ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH "/home/smirnov-i/.conan/data/xorg/system/_/_/package/5ab84d6acfe1f23c4fae0ab88f26e3a396351ac9/" ${CMAKE_PREFIX_PATH})

foreach(_BUILD_MODULE_PATH ${xorg_BUILD_MODULES_PATHS_RELEASE})
    include(${_BUILD_MODULE_PATH})
endforeach()

set(xorg_COMPONENTS_RELEASE xorg::x11 xorg::x11-xcb xorg::fontenc xorg::ice xorg::sm xorg::xau xorg::xaw7 xorg::xcomposite xorg::xcursor xorg::xdamage xorg::xdmcp xorg::xext xorg::xfixes xorg::xft xorg::xi xorg::xinerama xorg::xkbfile xorg::xmu xorg::xmuu xorg::xpm xorg::xrandr xorg::xrender xorg::xres xorg::xscrnsaver xorg::xt xorg::xtst xorg::xv xorg::xvmc xorg::xxf86vm xorg::xtrans xorg::xcb-xkb xorg::xcb-icccm xorg::xcb-image xorg::xcb-keysyms xorg::xcb-randr xorg::xcb-render xorg::xcb-renderutil xorg::xcb-shape xorg::xcb-shm xorg::xcb-sync xorg::xcb-xfixes xorg::xcb-xinerama xorg::xcb xorg::xkeyboard-config)

########### COMPONENT xkeyboard-config VARIABLES #############################################

set(xorg_xkeyboard-config_INCLUDE_DIRS_RELEASE )
set(xorg_xkeyboard-config_INCLUDE_DIR_RELEASE "")
set(xorg_xkeyboard-config_INCLUDES_RELEASE )
set(xorg_xkeyboard-config_LIB_DIRS_RELEASE )
set(xorg_xkeyboard-config_RES_DIRS_RELEASE )
set(xorg_xkeyboard-config_DEFINITIONS_RELEASE )
set(xorg_xkeyboard-config_COMPILE_DEFINITIONS_RELEASE )
set(xorg_xkeyboard-config_COMPILE_OPTIONS_C_RELEASE "")
set(xorg_xkeyboard-config_COMPILE_OPTIONS_CXX_RELEASE "")
set(xorg_xkeyboard-config_LIBS_RELEASE )
set(xorg_xkeyboard-config_SYSTEM_LIBS_RELEASE )
set(xorg_xkeyboard-config_FRAMEWORK_DIRS_RELEASE )
set(xorg_xkeyboard-config_FRAMEWORKS_RELEASE )
set(xorg_xkeyboard-config_BUILD_MODULES_PATHS_RELEASE )
set(xorg_xkeyboard-config_DEPENDENCIES_RELEASE )
set(xorg_xkeyboard-config_LINKER_FLAGS_LIST_RELEASE
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>
)

########## COMPONENT xkeyboard-config FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(xorg_xkeyboard-config_FRAMEWORKS_FOUND_RELEASE "")
conan_find_apple_frameworks(xorg_xkeyboard-config_FRAMEWORKS_FOUND_RELEASE "${xorg_xkeyboard-config_FRAMEWORKS_RELEASE}" "${xorg_xkeyboard-config_FRAMEWORK_DIRS_RELEASE}")

set(xorg_xkeyboard-config_LIB_TARGETS_RELEASE "")
set(xorg_xkeyboard-config_NOT_USED_RELEASE "")
set(xorg_xkeyboard-config_LIBS_FRAMEWORKS_DEPS_RELEASE ${xorg_xkeyboard-config_FRAMEWORKS_FOUND_RELEASE} ${xorg_xkeyboard-config_SYSTEM_LIBS_RELEASE} ${xorg_xkeyboard-config_DEPENDENCIES_RELEASE})
conan_package_library_targets("${xorg_xkeyboard-config_LIBS_RELEASE}"
                              "${xorg_xkeyboard-config_LIB_DIRS_RELEASE}"
                              "${xorg_xkeyboard-config_LIBS_FRAMEWORKS_DEPS_RELEASE}"
                              xorg_xkeyboard-config_NOT_USED_RELEASE
                              xorg_xkeyboard-config_LIB_TARGETS_RELEASE
                              "RELEASE"
                              "xorg_xkeyboard-config")

set(xorg_xkeyboard-config_LINK_LIBS_RELEASE ${xorg_xkeyboard-config_LIB_TARGETS_RELEASE} ${xorg_xkeyboard-config_LIBS_FRAMEWORKS_DEPS_RELEASE})

########### COMPONENT xcb VARIABLES #############################################

set(xorg_xcb_INCLUDE_DIRS_RELEASE )
set(xorg_xcb_INCLUDE_DIR_RELEASE "")
set(xorg_xcb_INCLUDES_RELEASE )
set(xorg_xcb_LIB_DIRS_RELEASE )
set(xorg_xcb_RES_DIRS_RELEASE )
set(xorg_xcb_DEFINITIONS_RELEASE )
set(xorg_xcb_COMPILE_DEFINITIONS_RELEASE )
set(xorg_xcb_COMPILE_OPTIONS_C_RELEASE "")
set(xorg_xcb_COMPILE_OPTIONS_CXX_RELEASE "")
set(xorg_xcb_LIBS_RELEASE )
set(xorg_xcb_SYSTEM_LIBS_RELEASE xcb)
set(xorg_xcb_FRAMEWORK_DIRS_RELEASE )
set(xorg_xcb_FRAMEWORKS_RELEASE )
set(xorg_xcb_BUILD_MODULES_PATHS_RELEASE )
set(xorg_xcb_DEPENDENCIES_RELEASE )
set(xorg_xcb_LINKER_FLAGS_LIST_RELEASE
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>
)

########## COMPONENT xcb FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(xorg_xcb_FRAMEWORKS_FOUND_RELEASE "")
conan_find_apple_frameworks(xorg_xcb_FRAMEWORKS_FOUND_RELEASE "${xorg_xcb_FRAMEWORKS_RELEASE}" "${xorg_xcb_FRAMEWORK_DIRS_RELEASE}")

set(xorg_xcb_LIB_TARGETS_RELEASE "")
set(xorg_xcb_NOT_USED_RELEASE "")
set(xorg_xcb_LIBS_FRAMEWORKS_DEPS_RELEASE ${xorg_xcb_FRAMEWORKS_FOUND_RELEASE} ${xorg_xcb_SYSTEM_LIBS_RELEASE} ${xorg_xcb_DEPENDENCIES_RELEASE})
conan_package_library_targets("${xorg_xcb_LIBS_RELEASE}"
                              "${xorg_xcb_LIB_DIRS_RELEASE}"
                              "${xorg_xcb_LIBS_FRAMEWORKS_DEPS_RELEASE}"
                              xorg_xcb_NOT_USED_RELEASE
                              xorg_xcb_LIB_TARGETS_RELEASE
                              "RELEASE"
                              "xorg_xcb")

set(xorg_xcb_LINK_LIBS_RELEASE ${xorg_xcb_LIB_TARGETS_RELEASE} ${xorg_xcb_LIBS_FRAMEWORKS_DEPS_RELEASE})

########### COMPONENT xcb-xinerama VARIABLES #############################################

set(xorg_xcb-xinerama_INCLUDE_DIRS_RELEASE )
set(xorg_xcb-xinerama_INCLUDE_DIR_RELEASE "")
set(xorg_xcb-xinerama_INCLUDES_RELEASE )
set(xorg_xcb-xinerama_LIB_DIRS_RELEASE )
set(xorg_xcb-xinerama_RES_DIRS_RELEASE )
set(xorg_xcb-xinerama_DEFINITIONS_RELEASE )
set(xorg_xcb-xinerama_COMPILE_DEFINITIONS_RELEASE )
set(xorg_xcb-xinerama_COMPILE_OPTIONS_C_RELEASE "")
set(xorg_xcb-xinerama_COMPILE_OPTIONS_CXX_RELEASE "")
set(xorg_xcb-xinerama_LIBS_RELEASE )
set(xorg_xcb-xinerama_SYSTEM_LIBS_RELEASE xcb-xinerama)
set(xorg_xcb-xinerama_FRAMEWORK_DIRS_RELEASE )
set(xorg_xcb-xinerama_FRAMEWORKS_RELEASE )
set(xorg_xcb-xinerama_BUILD_MODULES_PATHS_RELEASE )
set(xorg_xcb-xinerama_DEPENDENCIES_RELEASE )
set(xorg_xcb-xinerama_LINKER_FLAGS_LIST_RELEASE
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>
)

########## COMPONENT xcb-xinerama FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(xorg_xcb-xinerama_FRAMEWORKS_FOUND_RELEASE "")
conan_find_apple_frameworks(xorg_xcb-xinerama_FRAMEWORKS_FOUND_RELEASE "${xorg_xcb-xinerama_FRAMEWORKS_RELEASE}" "${xorg_xcb-xinerama_FRAMEWORK_DIRS_RELEASE}")

set(xorg_xcb-xinerama_LIB_TARGETS_RELEASE "")
set(xorg_xcb-xinerama_NOT_USED_RELEASE "")
set(xorg_xcb-xinerama_LIBS_FRAMEWORKS_DEPS_RELEASE ${xorg_xcb-xinerama_FRAMEWORKS_FOUND_RELEASE} ${xorg_xcb-xinerama_SYSTEM_LIBS_RELEASE} ${xorg_xcb-xinerama_DEPENDENCIES_RELEASE})
conan_package_library_targets("${xorg_xcb-xinerama_LIBS_RELEASE}"
                              "${xorg_xcb-xinerama_LIB_DIRS_RELEASE}"
                              "${xorg_xcb-xinerama_LIBS_FRAMEWORKS_DEPS_RELEASE}"
                              xorg_xcb-xinerama_NOT_USED_RELEASE
                              xorg_xcb-xinerama_LIB_TARGETS_RELEASE
                              "RELEASE"
                              "xorg_xcb-xinerama")

set(xorg_xcb-xinerama_LINK_LIBS_RELEASE ${xorg_xcb-xinerama_LIB_TARGETS_RELEASE} ${xorg_xcb-xinerama_LIBS_FRAMEWORKS_DEPS_RELEASE})

########### COMPONENT xcb-xfixes VARIABLES #############################################

set(xorg_xcb-xfixes_INCLUDE_DIRS_RELEASE )
set(xorg_xcb-xfixes_INCLUDE_DIR_RELEASE "")
set(xorg_xcb-xfixes_INCLUDES_RELEASE )
set(xorg_xcb-xfixes_LIB_DIRS_RELEASE )
set(xorg_xcb-xfixes_RES_DIRS_RELEASE )
set(xorg_xcb-xfixes_DEFINITIONS_RELEASE )
set(xorg_xcb-xfixes_COMPILE_DEFINITIONS_RELEASE )
set(xorg_xcb-xfixes_COMPILE_OPTIONS_C_RELEASE "")
set(xorg_xcb-xfixes_COMPILE_OPTIONS_CXX_RELEASE "")
set(xorg_xcb-xfixes_LIBS_RELEASE )
set(xorg_xcb-xfixes_SYSTEM_LIBS_RELEASE xcb-xfixes)
set(xorg_xcb-xfixes_FRAMEWORK_DIRS_RELEASE )
set(xorg_xcb-xfixes_FRAMEWORKS_RELEASE )
set(xorg_xcb-xfixes_BUILD_MODULES_PATHS_RELEASE )
set(xorg_xcb-xfixes_DEPENDENCIES_RELEASE )
set(xorg_xcb-xfixes_LINKER_FLAGS_LIST_RELEASE
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>
)

########## COMPONENT xcb-xfixes FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(xorg_xcb-xfixes_FRAMEWORKS_FOUND_RELEASE "")
conan_find_apple_frameworks(xorg_xcb-xfixes_FRAMEWORKS_FOUND_RELEASE "${xorg_xcb-xfixes_FRAMEWORKS_RELEASE}" "${xorg_xcb-xfixes_FRAMEWORK_DIRS_RELEASE}")

set(xorg_xcb-xfixes_LIB_TARGETS_RELEASE "")
set(xorg_xcb-xfixes_NOT_USED_RELEASE "")
set(xorg_xcb-xfixes_LIBS_FRAMEWORKS_DEPS_RELEASE ${xorg_xcb-xfixes_FRAMEWORKS_FOUND_RELEASE} ${xorg_xcb-xfixes_SYSTEM_LIBS_RELEASE} ${xorg_xcb-xfixes_DEPENDENCIES_RELEASE})
conan_package_library_targets("${xorg_xcb-xfixes_LIBS_RELEASE}"
                              "${xorg_xcb-xfixes_LIB_DIRS_RELEASE}"
                              "${xorg_xcb-xfixes_LIBS_FRAMEWORKS_DEPS_RELEASE}"
                              xorg_xcb-xfixes_NOT_USED_RELEASE
                              xorg_xcb-xfixes_LIB_TARGETS_RELEASE
                              "RELEASE"
                              "xorg_xcb-xfixes")

set(xorg_xcb-xfixes_LINK_LIBS_RELEASE ${xorg_xcb-xfixes_LIB_TARGETS_RELEASE} ${xorg_xcb-xfixes_LIBS_FRAMEWORKS_DEPS_RELEASE})

########### COMPONENT xcb-sync VARIABLES #############################################

set(xorg_xcb-sync_INCLUDE_DIRS_RELEASE )
set(xorg_xcb-sync_INCLUDE_DIR_RELEASE "")
set(xorg_xcb-sync_INCLUDES_RELEASE )
set(xorg_xcb-sync_LIB_DIRS_RELEASE )
set(xorg_xcb-sync_RES_DIRS_RELEASE )
set(xorg_xcb-sync_DEFINITIONS_RELEASE )
set(xorg_xcb-sync_COMPILE_DEFINITIONS_RELEASE )
set(xorg_xcb-sync_COMPILE_OPTIONS_C_RELEASE "")
set(xorg_xcb-sync_COMPILE_OPTIONS_CXX_RELEASE "")
set(xorg_xcb-sync_LIBS_RELEASE )
set(xorg_xcb-sync_SYSTEM_LIBS_RELEASE xcb-sync)
set(xorg_xcb-sync_FRAMEWORK_DIRS_RELEASE )
set(xorg_xcb-sync_FRAMEWORKS_RELEASE )
set(xorg_xcb-sync_BUILD_MODULES_PATHS_RELEASE )
set(xorg_xcb-sync_DEPENDENCIES_RELEASE )
set(xorg_xcb-sync_LINKER_FLAGS_LIST_RELEASE
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>
)

########## COMPONENT xcb-sync FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(xorg_xcb-sync_FRAMEWORKS_FOUND_RELEASE "")
conan_find_apple_frameworks(xorg_xcb-sync_FRAMEWORKS_FOUND_RELEASE "${xorg_xcb-sync_FRAMEWORKS_RELEASE}" "${xorg_xcb-sync_FRAMEWORK_DIRS_RELEASE}")

set(xorg_xcb-sync_LIB_TARGETS_RELEASE "")
set(xorg_xcb-sync_NOT_USED_RELEASE "")
set(xorg_xcb-sync_LIBS_FRAMEWORKS_DEPS_RELEASE ${xorg_xcb-sync_FRAMEWORKS_FOUND_RELEASE} ${xorg_xcb-sync_SYSTEM_LIBS_RELEASE} ${xorg_xcb-sync_DEPENDENCIES_RELEASE})
conan_package_library_targets("${xorg_xcb-sync_LIBS_RELEASE}"
                              "${xorg_xcb-sync_LIB_DIRS_RELEASE}"
                              "${xorg_xcb-sync_LIBS_FRAMEWORKS_DEPS_RELEASE}"
                              xorg_xcb-sync_NOT_USED_RELEASE
                              xorg_xcb-sync_LIB_TARGETS_RELEASE
                              "RELEASE"
                              "xorg_xcb-sync")

set(xorg_xcb-sync_LINK_LIBS_RELEASE ${xorg_xcb-sync_LIB_TARGETS_RELEASE} ${xorg_xcb-sync_LIBS_FRAMEWORKS_DEPS_RELEASE})

########### COMPONENT xcb-shm VARIABLES #############################################

set(xorg_xcb-shm_INCLUDE_DIRS_RELEASE )
set(xorg_xcb-shm_INCLUDE_DIR_RELEASE "")
set(xorg_xcb-shm_INCLUDES_RELEASE )
set(xorg_xcb-shm_LIB_DIRS_RELEASE )
set(xorg_xcb-shm_RES_DIRS_RELEASE )
set(xorg_xcb-shm_DEFINITIONS_RELEASE )
set(xorg_xcb-shm_COMPILE_DEFINITIONS_RELEASE )
set(xorg_xcb-shm_COMPILE_OPTIONS_C_RELEASE "")
set(xorg_xcb-shm_COMPILE_OPTIONS_CXX_RELEASE "")
set(xorg_xcb-shm_LIBS_RELEASE )
set(xorg_xcb-shm_SYSTEM_LIBS_RELEASE xcb-shm)
set(xorg_xcb-shm_FRAMEWORK_DIRS_RELEASE )
set(xorg_xcb-shm_FRAMEWORKS_RELEASE )
set(xorg_xcb-shm_BUILD_MODULES_PATHS_RELEASE )
set(xorg_xcb-shm_DEPENDENCIES_RELEASE )
set(xorg_xcb-shm_LINKER_FLAGS_LIST_RELEASE
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>
)

########## COMPONENT xcb-shm FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(xorg_xcb-shm_FRAMEWORKS_FOUND_RELEASE "")
conan_find_apple_frameworks(xorg_xcb-shm_FRAMEWORKS_FOUND_RELEASE "${xorg_xcb-shm_FRAMEWORKS_RELEASE}" "${xorg_xcb-shm_FRAMEWORK_DIRS_RELEASE}")

set(xorg_xcb-shm_LIB_TARGETS_RELEASE "")
set(xorg_xcb-shm_NOT_USED_RELEASE "")
set(xorg_xcb-shm_LIBS_FRAMEWORKS_DEPS_RELEASE ${xorg_xcb-shm_FRAMEWORKS_FOUND_RELEASE} ${xorg_xcb-shm_SYSTEM_LIBS_RELEASE} ${xorg_xcb-shm_DEPENDENCIES_RELEASE})
conan_package_library_targets("${xorg_xcb-shm_LIBS_RELEASE}"
                              "${xorg_xcb-shm_LIB_DIRS_RELEASE}"
                              "${xorg_xcb-shm_LIBS_FRAMEWORKS_DEPS_RELEASE}"
                              xorg_xcb-shm_NOT_USED_RELEASE
                              xorg_xcb-shm_LIB_TARGETS_RELEASE
                              "RELEASE"
                              "xorg_xcb-shm")

set(xorg_xcb-shm_LINK_LIBS_RELEASE ${xorg_xcb-shm_LIB_TARGETS_RELEASE} ${xorg_xcb-shm_LIBS_FRAMEWORKS_DEPS_RELEASE})

########### COMPONENT xcb-shape VARIABLES #############################################

set(xorg_xcb-shape_INCLUDE_DIRS_RELEASE )
set(xorg_xcb-shape_INCLUDE_DIR_RELEASE "")
set(xorg_xcb-shape_INCLUDES_RELEASE )
set(xorg_xcb-shape_LIB_DIRS_RELEASE )
set(xorg_xcb-shape_RES_DIRS_RELEASE )
set(xorg_xcb-shape_DEFINITIONS_RELEASE )
set(xorg_xcb-shape_COMPILE_DEFINITIONS_RELEASE )
set(xorg_xcb-shape_COMPILE_OPTIONS_C_RELEASE "")
set(xorg_xcb-shape_COMPILE_OPTIONS_CXX_RELEASE "")
set(xorg_xcb-shape_LIBS_RELEASE )
set(xorg_xcb-shape_SYSTEM_LIBS_RELEASE xcb-shape)
set(xorg_xcb-shape_FRAMEWORK_DIRS_RELEASE )
set(xorg_xcb-shape_FRAMEWORKS_RELEASE )
set(xorg_xcb-shape_BUILD_MODULES_PATHS_RELEASE )
set(xorg_xcb-shape_DEPENDENCIES_RELEASE )
set(xorg_xcb-shape_LINKER_FLAGS_LIST_RELEASE
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>
)

########## COMPONENT xcb-shape FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(xorg_xcb-shape_FRAMEWORKS_FOUND_RELEASE "")
conan_find_apple_frameworks(xorg_xcb-shape_FRAMEWORKS_FOUND_RELEASE "${xorg_xcb-shape_FRAMEWORKS_RELEASE}" "${xorg_xcb-shape_FRAMEWORK_DIRS_RELEASE}")

set(xorg_xcb-shape_LIB_TARGETS_RELEASE "")
set(xorg_xcb-shape_NOT_USED_RELEASE "")
set(xorg_xcb-shape_LIBS_FRAMEWORKS_DEPS_RELEASE ${xorg_xcb-shape_FRAMEWORKS_FOUND_RELEASE} ${xorg_xcb-shape_SYSTEM_LIBS_RELEASE} ${xorg_xcb-shape_DEPENDENCIES_RELEASE})
conan_package_library_targets("${xorg_xcb-shape_LIBS_RELEASE}"
                              "${xorg_xcb-shape_LIB_DIRS_RELEASE}"
                              "${xorg_xcb-shape_LIBS_FRAMEWORKS_DEPS_RELEASE}"
                              xorg_xcb-shape_NOT_USED_RELEASE
                              xorg_xcb-shape_LIB_TARGETS_RELEASE
                              "RELEASE"
                              "xorg_xcb-shape")

set(xorg_xcb-shape_LINK_LIBS_RELEASE ${xorg_xcb-shape_LIB_TARGETS_RELEASE} ${xorg_xcb-shape_LIBS_FRAMEWORKS_DEPS_RELEASE})

########### COMPONENT xcb-renderutil VARIABLES #############################################

set(xorg_xcb-renderutil_INCLUDE_DIRS_RELEASE )
set(xorg_xcb-renderutil_INCLUDE_DIR_RELEASE "")
set(xorg_xcb-renderutil_INCLUDES_RELEASE )
set(xorg_xcb-renderutil_LIB_DIRS_RELEASE )
set(xorg_xcb-renderutil_RES_DIRS_RELEASE )
set(xorg_xcb-renderutil_DEFINITIONS_RELEASE )
set(xorg_xcb-renderutil_COMPILE_DEFINITIONS_RELEASE )
set(xorg_xcb-renderutil_COMPILE_OPTIONS_C_RELEASE "")
set(xorg_xcb-renderutil_COMPILE_OPTIONS_CXX_RELEASE "")
set(xorg_xcb-renderutil_LIBS_RELEASE )
set(xorg_xcb-renderutil_SYSTEM_LIBS_RELEASE xcb-render-util xcb xcb-render)
set(xorg_xcb-renderutil_FRAMEWORK_DIRS_RELEASE )
set(xorg_xcb-renderutil_FRAMEWORKS_RELEASE )
set(xorg_xcb-renderutil_BUILD_MODULES_PATHS_RELEASE )
set(xorg_xcb-renderutil_DEPENDENCIES_RELEASE )
set(xorg_xcb-renderutil_LINKER_FLAGS_LIST_RELEASE
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>
)

########## COMPONENT xcb-renderutil FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(xorg_xcb-renderutil_FRAMEWORKS_FOUND_RELEASE "")
conan_find_apple_frameworks(xorg_xcb-renderutil_FRAMEWORKS_FOUND_RELEASE "${xorg_xcb-renderutil_FRAMEWORKS_RELEASE}" "${xorg_xcb-renderutil_FRAMEWORK_DIRS_RELEASE}")

set(xorg_xcb-renderutil_LIB_TARGETS_RELEASE "")
set(xorg_xcb-renderutil_NOT_USED_RELEASE "")
set(xorg_xcb-renderutil_LIBS_FRAMEWORKS_DEPS_RELEASE ${xorg_xcb-renderutil_FRAMEWORKS_FOUND_RELEASE} ${xorg_xcb-renderutil_SYSTEM_LIBS_RELEASE} ${xorg_xcb-renderutil_DEPENDENCIES_RELEASE})
conan_package_library_targets("${xorg_xcb-renderutil_LIBS_RELEASE}"
                              "${xorg_xcb-renderutil_LIB_DIRS_RELEASE}"
                              "${xorg_xcb-renderutil_LIBS_FRAMEWORKS_DEPS_RELEASE}"
                              xorg_xcb-renderutil_NOT_USED_RELEASE
                              xorg_xcb-renderutil_LIB_TARGETS_RELEASE
                              "RELEASE"
                              "xorg_xcb-renderutil")

set(xorg_xcb-renderutil_LINK_LIBS_RELEASE ${xorg_xcb-renderutil_LIB_TARGETS_RELEASE} ${xorg_xcb-renderutil_LIBS_FRAMEWORKS_DEPS_RELEASE})

########### COMPONENT xcb-render VARIABLES #############################################

set(xorg_xcb-render_INCLUDE_DIRS_RELEASE )
set(xorg_xcb-render_INCLUDE_DIR_RELEASE "")
set(xorg_xcb-render_INCLUDES_RELEASE )
set(xorg_xcb-render_LIB_DIRS_RELEASE )
set(xorg_xcb-render_RES_DIRS_RELEASE )
set(xorg_xcb-render_DEFINITIONS_RELEASE )
set(xorg_xcb-render_COMPILE_DEFINITIONS_RELEASE )
set(xorg_xcb-render_COMPILE_OPTIONS_C_RELEASE "")
set(xorg_xcb-render_COMPILE_OPTIONS_CXX_RELEASE "")
set(xorg_xcb-render_LIBS_RELEASE )
set(xorg_xcb-render_SYSTEM_LIBS_RELEASE xcb-render)
set(xorg_xcb-render_FRAMEWORK_DIRS_RELEASE )
set(xorg_xcb-render_FRAMEWORKS_RELEASE )
set(xorg_xcb-render_BUILD_MODULES_PATHS_RELEASE )
set(xorg_xcb-render_DEPENDENCIES_RELEASE )
set(xorg_xcb-render_LINKER_FLAGS_LIST_RELEASE
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>
)

########## COMPONENT xcb-render FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(xorg_xcb-render_FRAMEWORKS_FOUND_RELEASE "")
conan_find_apple_frameworks(xorg_xcb-render_FRAMEWORKS_FOUND_RELEASE "${xorg_xcb-render_FRAMEWORKS_RELEASE}" "${xorg_xcb-render_FRAMEWORK_DIRS_RELEASE}")

set(xorg_xcb-render_LIB_TARGETS_RELEASE "")
set(xorg_xcb-render_NOT_USED_RELEASE "")
set(xorg_xcb-render_LIBS_FRAMEWORKS_DEPS_RELEASE ${xorg_xcb-render_FRAMEWORKS_FOUND_RELEASE} ${xorg_xcb-render_SYSTEM_LIBS_RELEASE} ${xorg_xcb-render_DEPENDENCIES_RELEASE})
conan_package_library_targets("${xorg_xcb-render_LIBS_RELEASE}"
                              "${xorg_xcb-render_LIB_DIRS_RELEASE}"
                              "${xorg_xcb-render_LIBS_FRAMEWORKS_DEPS_RELEASE}"
                              xorg_xcb-render_NOT_USED_RELEASE
                              xorg_xcb-render_LIB_TARGETS_RELEASE
                              "RELEASE"
                              "xorg_xcb-render")

set(xorg_xcb-render_LINK_LIBS_RELEASE ${xorg_xcb-render_LIB_TARGETS_RELEASE} ${xorg_xcb-render_LIBS_FRAMEWORKS_DEPS_RELEASE})

########### COMPONENT xcb-randr VARIABLES #############################################

set(xorg_xcb-randr_INCLUDE_DIRS_RELEASE )
set(xorg_xcb-randr_INCLUDE_DIR_RELEASE "")
set(xorg_xcb-randr_INCLUDES_RELEASE )
set(xorg_xcb-randr_LIB_DIRS_RELEASE )
set(xorg_xcb-randr_RES_DIRS_RELEASE )
set(xorg_xcb-randr_DEFINITIONS_RELEASE )
set(xorg_xcb-randr_COMPILE_DEFINITIONS_RELEASE )
set(xorg_xcb-randr_COMPILE_OPTIONS_C_RELEASE "")
set(xorg_xcb-randr_COMPILE_OPTIONS_CXX_RELEASE "")
set(xorg_xcb-randr_LIBS_RELEASE )
set(xorg_xcb-randr_SYSTEM_LIBS_RELEASE xcb-randr)
set(xorg_xcb-randr_FRAMEWORK_DIRS_RELEASE )
set(xorg_xcb-randr_FRAMEWORKS_RELEASE )
set(xorg_xcb-randr_BUILD_MODULES_PATHS_RELEASE )
set(xorg_xcb-randr_DEPENDENCIES_RELEASE )
set(xorg_xcb-randr_LINKER_FLAGS_LIST_RELEASE
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>
)

########## COMPONENT xcb-randr FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(xorg_xcb-randr_FRAMEWORKS_FOUND_RELEASE "")
conan_find_apple_frameworks(xorg_xcb-randr_FRAMEWORKS_FOUND_RELEASE "${xorg_xcb-randr_FRAMEWORKS_RELEASE}" "${xorg_xcb-randr_FRAMEWORK_DIRS_RELEASE}")

set(xorg_xcb-randr_LIB_TARGETS_RELEASE "")
set(xorg_xcb-randr_NOT_USED_RELEASE "")
set(xorg_xcb-randr_LIBS_FRAMEWORKS_DEPS_RELEASE ${xorg_xcb-randr_FRAMEWORKS_FOUND_RELEASE} ${xorg_xcb-randr_SYSTEM_LIBS_RELEASE} ${xorg_xcb-randr_DEPENDENCIES_RELEASE})
conan_package_library_targets("${xorg_xcb-randr_LIBS_RELEASE}"
                              "${xorg_xcb-randr_LIB_DIRS_RELEASE}"
                              "${xorg_xcb-randr_LIBS_FRAMEWORKS_DEPS_RELEASE}"
                              xorg_xcb-randr_NOT_USED_RELEASE
                              xorg_xcb-randr_LIB_TARGETS_RELEASE
                              "RELEASE"
                              "xorg_xcb-randr")

set(xorg_xcb-randr_LINK_LIBS_RELEASE ${xorg_xcb-randr_LIB_TARGETS_RELEASE} ${xorg_xcb-randr_LIBS_FRAMEWORKS_DEPS_RELEASE})

########### COMPONENT xcb-keysyms VARIABLES #############################################

set(xorg_xcb-keysyms_INCLUDE_DIRS_RELEASE )
set(xorg_xcb-keysyms_INCLUDE_DIR_RELEASE "")
set(xorg_xcb-keysyms_INCLUDES_RELEASE )
set(xorg_xcb-keysyms_LIB_DIRS_RELEASE )
set(xorg_xcb-keysyms_RES_DIRS_RELEASE )
set(xorg_xcb-keysyms_DEFINITIONS_RELEASE )
set(xorg_xcb-keysyms_COMPILE_DEFINITIONS_RELEASE )
set(xorg_xcb-keysyms_COMPILE_OPTIONS_C_RELEASE "")
set(xorg_xcb-keysyms_COMPILE_OPTIONS_CXX_RELEASE "")
set(xorg_xcb-keysyms_LIBS_RELEASE )
set(xorg_xcb-keysyms_SYSTEM_LIBS_RELEASE xcb-keysyms xcb)
set(xorg_xcb-keysyms_FRAMEWORK_DIRS_RELEASE )
set(xorg_xcb-keysyms_FRAMEWORKS_RELEASE )
set(xorg_xcb-keysyms_BUILD_MODULES_PATHS_RELEASE )
set(xorg_xcb-keysyms_DEPENDENCIES_RELEASE )
set(xorg_xcb-keysyms_LINKER_FLAGS_LIST_RELEASE
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>
)

########## COMPONENT xcb-keysyms FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(xorg_xcb-keysyms_FRAMEWORKS_FOUND_RELEASE "")
conan_find_apple_frameworks(xorg_xcb-keysyms_FRAMEWORKS_FOUND_RELEASE "${xorg_xcb-keysyms_FRAMEWORKS_RELEASE}" "${xorg_xcb-keysyms_FRAMEWORK_DIRS_RELEASE}")

set(xorg_xcb-keysyms_LIB_TARGETS_RELEASE "")
set(xorg_xcb-keysyms_NOT_USED_RELEASE "")
set(xorg_xcb-keysyms_LIBS_FRAMEWORKS_DEPS_RELEASE ${xorg_xcb-keysyms_FRAMEWORKS_FOUND_RELEASE} ${xorg_xcb-keysyms_SYSTEM_LIBS_RELEASE} ${xorg_xcb-keysyms_DEPENDENCIES_RELEASE})
conan_package_library_targets("${xorg_xcb-keysyms_LIBS_RELEASE}"
                              "${xorg_xcb-keysyms_LIB_DIRS_RELEASE}"
                              "${xorg_xcb-keysyms_LIBS_FRAMEWORKS_DEPS_RELEASE}"
                              xorg_xcb-keysyms_NOT_USED_RELEASE
                              xorg_xcb-keysyms_LIB_TARGETS_RELEASE
                              "RELEASE"
                              "xorg_xcb-keysyms")

set(xorg_xcb-keysyms_LINK_LIBS_RELEASE ${xorg_xcb-keysyms_LIB_TARGETS_RELEASE} ${xorg_xcb-keysyms_LIBS_FRAMEWORKS_DEPS_RELEASE})

########### COMPONENT xcb-image VARIABLES #############################################

set(xorg_xcb-image_INCLUDE_DIRS_RELEASE )
set(xorg_xcb-image_INCLUDE_DIR_RELEASE "")
set(xorg_xcb-image_INCLUDES_RELEASE )
set(xorg_xcb-image_LIB_DIRS_RELEASE )
set(xorg_xcb-image_RES_DIRS_RELEASE )
set(xorg_xcb-image_DEFINITIONS_RELEASE )
set(xorg_xcb-image_COMPILE_DEFINITIONS_RELEASE )
set(xorg_xcb-image_COMPILE_OPTIONS_C_RELEASE "")
set(xorg_xcb-image_COMPILE_OPTIONS_CXX_RELEASE "")
set(xorg_xcb-image_LIBS_RELEASE )
set(xorg_xcb-image_SYSTEM_LIBS_RELEASE xcb-image xcb xcb-shm)
set(xorg_xcb-image_FRAMEWORK_DIRS_RELEASE )
set(xorg_xcb-image_FRAMEWORKS_RELEASE )
set(xorg_xcb-image_BUILD_MODULES_PATHS_RELEASE )
set(xorg_xcb-image_DEPENDENCIES_RELEASE )
set(xorg_xcb-image_LINKER_FLAGS_LIST_RELEASE
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>
)

########## COMPONENT xcb-image FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(xorg_xcb-image_FRAMEWORKS_FOUND_RELEASE "")
conan_find_apple_frameworks(xorg_xcb-image_FRAMEWORKS_FOUND_RELEASE "${xorg_xcb-image_FRAMEWORKS_RELEASE}" "${xorg_xcb-image_FRAMEWORK_DIRS_RELEASE}")

set(xorg_xcb-image_LIB_TARGETS_RELEASE "")
set(xorg_xcb-image_NOT_USED_RELEASE "")
set(xorg_xcb-image_LIBS_FRAMEWORKS_DEPS_RELEASE ${xorg_xcb-image_FRAMEWORKS_FOUND_RELEASE} ${xorg_xcb-image_SYSTEM_LIBS_RELEASE} ${xorg_xcb-image_DEPENDENCIES_RELEASE})
conan_package_library_targets("${xorg_xcb-image_LIBS_RELEASE}"
                              "${xorg_xcb-image_LIB_DIRS_RELEASE}"
                              "${xorg_xcb-image_LIBS_FRAMEWORKS_DEPS_RELEASE}"
                              xorg_xcb-image_NOT_USED_RELEASE
                              xorg_xcb-image_LIB_TARGETS_RELEASE
                              "RELEASE"
                              "xorg_xcb-image")

set(xorg_xcb-image_LINK_LIBS_RELEASE ${xorg_xcb-image_LIB_TARGETS_RELEASE} ${xorg_xcb-image_LIBS_FRAMEWORKS_DEPS_RELEASE})

########### COMPONENT xcb-icccm VARIABLES #############################################

set(xorg_xcb-icccm_INCLUDE_DIRS_RELEASE )
set(xorg_xcb-icccm_INCLUDE_DIR_RELEASE "")
set(xorg_xcb-icccm_INCLUDES_RELEASE )
set(xorg_xcb-icccm_LIB_DIRS_RELEASE )
set(xorg_xcb-icccm_RES_DIRS_RELEASE )
set(xorg_xcb-icccm_DEFINITIONS_RELEASE )
set(xorg_xcb-icccm_COMPILE_DEFINITIONS_RELEASE )
set(xorg_xcb-icccm_COMPILE_OPTIONS_C_RELEASE "")
set(xorg_xcb-icccm_COMPILE_OPTIONS_CXX_RELEASE "")
set(xorg_xcb-icccm_LIBS_RELEASE )
set(xorg_xcb-icccm_SYSTEM_LIBS_RELEASE xcb-icccm xcb)
set(xorg_xcb-icccm_FRAMEWORK_DIRS_RELEASE )
set(xorg_xcb-icccm_FRAMEWORKS_RELEASE )
set(xorg_xcb-icccm_BUILD_MODULES_PATHS_RELEASE )
set(xorg_xcb-icccm_DEPENDENCIES_RELEASE )
set(xorg_xcb-icccm_LINKER_FLAGS_LIST_RELEASE
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>
)

########## COMPONENT xcb-icccm FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(xorg_xcb-icccm_FRAMEWORKS_FOUND_RELEASE "")
conan_find_apple_frameworks(xorg_xcb-icccm_FRAMEWORKS_FOUND_RELEASE "${xorg_xcb-icccm_FRAMEWORKS_RELEASE}" "${xorg_xcb-icccm_FRAMEWORK_DIRS_RELEASE}")

set(xorg_xcb-icccm_LIB_TARGETS_RELEASE "")
set(xorg_xcb-icccm_NOT_USED_RELEASE "")
set(xorg_xcb-icccm_LIBS_FRAMEWORKS_DEPS_RELEASE ${xorg_xcb-icccm_FRAMEWORKS_FOUND_RELEASE} ${xorg_xcb-icccm_SYSTEM_LIBS_RELEASE} ${xorg_xcb-icccm_DEPENDENCIES_RELEASE})
conan_package_library_targets("${xorg_xcb-icccm_LIBS_RELEASE}"
                              "${xorg_xcb-icccm_LIB_DIRS_RELEASE}"
                              "${xorg_xcb-icccm_LIBS_FRAMEWORKS_DEPS_RELEASE}"
                              xorg_xcb-icccm_NOT_USED_RELEASE
                              xorg_xcb-icccm_LIB_TARGETS_RELEASE
                              "RELEASE"
                              "xorg_xcb-icccm")

set(xorg_xcb-icccm_LINK_LIBS_RELEASE ${xorg_xcb-icccm_LIB_TARGETS_RELEASE} ${xorg_xcb-icccm_LIBS_FRAMEWORKS_DEPS_RELEASE})

########### COMPONENT xcb-xkb VARIABLES #############################################

set(xorg_xcb-xkb_INCLUDE_DIRS_RELEASE )
set(xorg_xcb-xkb_INCLUDE_DIR_RELEASE "")
set(xorg_xcb-xkb_INCLUDES_RELEASE )
set(xorg_xcb-xkb_LIB_DIRS_RELEASE )
set(xorg_xcb-xkb_RES_DIRS_RELEASE )
set(xorg_xcb-xkb_DEFINITIONS_RELEASE )
set(xorg_xcb-xkb_COMPILE_DEFINITIONS_RELEASE )
set(xorg_xcb-xkb_COMPILE_OPTIONS_C_RELEASE "")
set(xorg_xcb-xkb_COMPILE_OPTIONS_CXX_RELEASE "")
set(xorg_xcb-xkb_LIBS_RELEASE )
set(xorg_xcb-xkb_SYSTEM_LIBS_RELEASE xcb-xkb)
set(xorg_xcb-xkb_FRAMEWORK_DIRS_RELEASE )
set(xorg_xcb-xkb_FRAMEWORKS_RELEASE )
set(xorg_xcb-xkb_BUILD_MODULES_PATHS_RELEASE )
set(xorg_xcb-xkb_DEPENDENCIES_RELEASE )
set(xorg_xcb-xkb_LINKER_FLAGS_LIST_RELEASE
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>
)

########## COMPONENT xcb-xkb FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(xorg_xcb-xkb_FRAMEWORKS_FOUND_RELEASE "")
conan_find_apple_frameworks(xorg_xcb-xkb_FRAMEWORKS_FOUND_RELEASE "${xorg_xcb-xkb_FRAMEWORKS_RELEASE}" "${xorg_xcb-xkb_FRAMEWORK_DIRS_RELEASE}")

set(xorg_xcb-xkb_LIB_TARGETS_RELEASE "")
set(xorg_xcb-xkb_NOT_USED_RELEASE "")
set(xorg_xcb-xkb_LIBS_FRAMEWORKS_DEPS_RELEASE ${xorg_xcb-xkb_FRAMEWORKS_FOUND_RELEASE} ${xorg_xcb-xkb_SYSTEM_LIBS_RELEASE} ${xorg_xcb-xkb_DEPENDENCIES_RELEASE})
conan_package_library_targets("${xorg_xcb-xkb_LIBS_RELEASE}"
                              "${xorg_xcb-xkb_LIB_DIRS_RELEASE}"
                              "${xorg_xcb-xkb_LIBS_FRAMEWORKS_DEPS_RELEASE}"
                              xorg_xcb-xkb_NOT_USED_RELEASE
                              xorg_xcb-xkb_LIB_TARGETS_RELEASE
                              "RELEASE"
                              "xorg_xcb-xkb")

set(xorg_xcb-xkb_LINK_LIBS_RELEASE ${xorg_xcb-xkb_LIB_TARGETS_RELEASE} ${xorg_xcb-xkb_LIBS_FRAMEWORKS_DEPS_RELEASE})

########### COMPONENT xtrans VARIABLES #############################################

set(xorg_xtrans_INCLUDE_DIRS_RELEASE )
set(xorg_xtrans_INCLUDE_DIR_RELEASE "")
set(xorg_xtrans_INCLUDES_RELEASE )
set(xorg_xtrans_LIB_DIRS_RELEASE )
set(xorg_xtrans_RES_DIRS_RELEASE )
set(xorg_xtrans_DEFINITIONS_RELEASE "-D_DEFAULT_SOURCE"
			"-D_BSD_SOURCE"
			"-DHAS_FCHOWN"
			"-DHAS_STICKY_DIR_BIT")
set(xorg_xtrans_COMPILE_DEFINITIONS_RELEASE "_DEFAULT_SOURCE"
			"_BSD_SOURCE"
			"HAS_FCHOWN"
			"HAS_STICKY_DIR_BIT")
set(xorg_xtrans_COMPILE_OPTIONS_C_RELEASE "")
set(xorg_xtrans_COMPILE_OPTIONS_CXX_RELEASE "")
set(xorg_xtrans_LIBS_RELEASE )
set(xorg_xtrans_SYSTEM_LIBS_RELEASE )
set(xorg_xtrans_FRAMEWORK_DIRS_RELEASE )
set(xorg_xtrans_FRAMEWORKS_RELEASE )
set(xorg_xtrans_BUILD_MODULES_PATHS_RELEASE )
set(xorg_xtrans_DEPENDENCIES_RELEASE )
set(xorg_xtrans_LINKER_FLAGS_LIST_RELEASE
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>
)

########## COMPONENT xtrans FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(xorg_xtrans_FRAMEWORKS_FOUND_RELEASE "")
conan_find_apple_frameworks(xorg_xtrans_FRAMEWORKS_FOUND_RELEASE "${xorg_xtrans_FRAMEWORKS_RELEASE}" "${xorg_xtrans_FRAMEWORK_DIRS_RELEASE}")

set(xorg_xtrans_LIB_TARGETS_RELEASE "")
set(xorg_xtrans_NOT_USED_RELEASE "")
set(xorg_xtrans_LIBS_FRAMEWORKS_DEPS_RELEASE ${xorg_xtrans_FRAMEWORKS_FOUND_RELEASE} ${xorg_xtrans_SYSTEM_LIBS_RELEASE} ${xorg_xtrans_DEPENDENCIES_RELEASE})
conan_package_library_targets("${xorg_xtrans_LIBS_RELEASE}"
                              "${xorg_xtrans_LIB_DIRS_RELEASE}"
                              "${xorg_xtrans_LIBS_FRAMEWORKS_DEPS_RELEASE}"
                              xorg_xtrans_NOT_USED_RELEASE
                              xorg_xtrans_LIB_TARGETS_RELEASE
                              "RELEASE"
                              "xorg_xtrans")

set(xorg_xtrans_LINK_LIBS_RELEASE ${xorg_xtrans_LIB_TARGETS_RELEASE} ${xorg_xtrans_LIBS_FRAMEWORKS_DEPS_RELEASE})

########### COMPONENT xxf86vm VARIABLES #############################################

set(xorg_xxf86vm_INCLUDE_DIRS_RELEASE )
set(xorg_xxf86vm_INCLUDE_DIR_RELEASE "")
set(xorg_xxf86vm_INCLUDES_RELEASE )
set(xorg_xxf86vm_LIB_DIRS_RELEASE )
set(xorg_xxf86vm_RES_DIRS_RELEASE )
set(xorg_xxf86vm_DEFINITIONS_RELEASE )
set(xorg_xxf86vm_COMPILE_DEFINITIONS_RELEASE )
set(xorg_xxf86vm_COMPILE_OPTIONS_C_RELEASE "")
set(xorg_xxf86vm_COMPILE_OPTIONS_CXX_RELEASE "")
set(xorg_xxf86vm_LIBS_RELEASE )
set(xorg_xxf86vm_SYSTEM_LIBS_RELEASE Xxf86vm)
set(xorg_xxf86vm_FRAMEWORK_DIRS_RELEASE )
set(xorg_xxf86vm_FRAMEWORKS_RELEASE )
set(xorg_xxf86vm_BUILD_MODULES_PATHS_RELEASE )
set(xorg_xxf86vm_DEPENDENCIES_RELEASE )
set(xorg_xxf86vm_LINKER_FLAGS_LIST_RELEASE
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>
)

########## COMPONENT xxf86vm FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(xorg_xxf86vm_FRAMEWORKS_FOUND_RELEASE "")
conan_find_apple_frameworks(xorg_xxf86vm_FRAMEWORKS_FOUND_RELEASE "${xorg_xxf86vm_FRAMEWORKS_RELEASE}" "${xorg_xxf86vm_FRAMEWORK_DIRS_RELEASE}")

set(xorg_xxf86vm_LIB_TARGETS_RELEASE "")
set(xorg_xxf86vm_NOT_USED_RELEASE "")
set(xorg_xxf86vm_LIBS_FRAMEWORKS_DEPS_RELEASE ${xorg_xxf86vm_FRAMEWORKS_FOUND_RELEASE} ${xorg_xxf86vm_SYSTEM_LIBS_RELEASE} ${xorg_xxf86vm_DEPENDENCIES_RELEASE})
conan_package_library_targets("${xorg_xxf86vm_LIBS_RELEASE}"
                              "${xorg_xxf86vm_LIB_DIRS_RELEASE}"
                              "${xorg_xxf86vm_LIBS_FRAMEWORKS_DEPS_RELEASE}"
                              xorg_xxf86vm_NOT_USED_RELEASE
                              xorg_xxf86vm_LIB_TARGETS_RELEASE
                              "RELEASE"
                              "xorg_xxf86vm")

set(xorg_xxf86vm_LINK_LIBS_RELEASE ${xorg_xxf86vm_LIB_TARGETS_RELEASE} ${xorg_xxf86vm_LIBS_FRAMEWORKS_DEPS_RELEASE})

########### COMPONENT xvmc VARIABLES #############################################

set(xorg_xvmc_INCLUDE_DIRS_RELEASE )
set(xorg_xvmc_INCLUDE_DIR_RELEASE "")
set(xorg_xvmc_INCLUDES_RELEASE )
set(xorg_xvmc_LIB_DIRS_RELEASE )
set(xorg_xvmc_RES_DIRS_RELEASE )
set(xorg_xvmc_DEFINITIONS_RELEASE )
set(xorg_xvmc_COMPILE_DEFINITIONS_RELEASE )
set(xorg_xvmc_COMPILE_OPTIONS_C_RELEASE "")
set(xorg_xvmc_COMPILE_OPTIONS_CXX_RELEASE "")
set(xorg_xvmc_LIBS_RELEASE )
set(xorg_xvmc_SYSTEM_LIBS_RELEASE XvMC)
set(xorg_xvmc_FRAMEWORK_DIRS_RELEASE )
set(xorg_xvmc_FRAMEWORKS_RELEASE )
set(xorg_xvmc_BUILD_MODULES_PATHS_RELEASE )
set(xorg_xvmc_DEPENDENCIES_RELEASE )
set(xorg_xvmc_LINKER_FLAGS_LIST_RELEASE
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>
)

########## COMPONENT xvmc FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(xorg_xvmc_FRAMEWORKS_FOUND_RELEASE "")
conan_find_apple_frameworks(xorg_xvmc_FRAMEWORKS_FOUND_RELEASE "${xorg_xvmc_FRAMEWORKS_RELEASE}" "${xorg_xvmc_FRAMEWORK_DIRS_RELEASE}")

set(xorg_xvmc_LIB_TARGETS_RELEASE "")
set(xorg_xvmc_NOT_USED_RELEASE "")
set(xorg_xvmc_LIBS_FRAMEWORKS_DEPS_RELEASE ${xorg_xvmc_FRAMEWORKS_FOUND_RELEASE} ${xorg_xvmc_SYSTEM_LIBS_RELEASE} ${xorg_xvmc_DEPENDENCIES_RELEASE})
conan_package_library_targets("${xorg_xvmc_LIBS_RELEASE}"
                              "${xorg_xvmc_LIB_DIRS_RELEASE}"
                              "${xorg_xvmc_LIBS_FRAMEWORKS_DEPS_RELEASE}"
                              xorg_xvmc_NOT_USED_RELEASE
                              xorg_xvmc_LIB_TARGETS_RELEASE
                              "RELEASE"
                              "xorg_xvmc")

set(xorg_xvmc_LINK_LIBS_RELEASE ${xorg_xvmc_LIB_TARGETS_RELEASE} ${xorg_xvmc_LIBS_FRAMEWORKS_DEPS_RELEASE})

########### COMPONENT xv VARIABLES #############################################

set(xorg_xv_INCLUDE_DIRS_RELEASE )
set(xorg_xv_INCLUDE_DIR_RELEASE "")
set(xorg_xv_INCLUDES_RELEASE )
set(xorg_xv_LIB_DIRS_RELEASE )
set(xorg_xv_RES_DIRS_RELEASE )
set(xorg_xv_DEFINITIONS_RELEASE )
set(xorg_xv_COMPILE_DEFINITIONS_RELEASE )
set(xorg_xv_COMPILE_OPTIONS_C_RELEASE "")
set(xorg_xv_COMPILE_OPTIONS_CXX_RELEASE "")
set(xorg_xv_LIBS_RELEASE )
set(xorg_xv_SYSTEM_LIBS_RELEASE Xv)
set(xorg_xv_FRAMEWORK_DIRS_RELEASE )
set(xorg_xv_FRAMEWORKS_RELEASE )
set(xorg_xv_BUILD_MODULES_PATHS_RELEASE )
set(xorg_xv_DEPENDENCIES_RELEASE )
set(xorg_xv_LINKER_FLAGS_LIST_RELEASE
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>
)

########## COMPONENT xv FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(xorg_xv_FRAMEWORKS_FOUND_RELEASE "")
conan_find_apple_frameworks(xorg_xv_FRAMEWORKS_FOUND_RELEASE "${xorg_xv_FRAMEWORKS_RELEASE}" "${xorg_xv_FRAMEWORK_DIRS_RELEASE}")

set(xorg_xv_LIB_TARGETS_RELEASE "")
set(xorg_xv_NOT_USED_RELEASE "")
set(xorg_xv_LIBS_FRAMEWORKS_DEPS_RELEASE ${xorg_xv_FRAMEWORKS_FOUND_RELEASE} ${xorg_xv_SYSTEM_LIBS_RELEASE} ${xorg_xv_DEPENDENCIES_RELEASE})
conan_package_library_targets("${xorg_xv_LIBS_RELEASE}"
                              "${xorg_xv_LIB_DIRS_RELEASE}"
                              "${xorg_xv_LIBS_FRAMEWORKS_DEPS_RELEASE}"
                              xorg_xv_NOT_USED_RELEASE
                              xorg_xv_LIB_TARGETS_RELEASE
                              "RELEASE"
                              "xorg_xv")

set(xorg_xv_LINK_LIBS_RELEASE ${xorg_xv_LIB_TARGETS_RELEASE} ${xorg_xv_LIBS_FRAMEWORKS_DEPS_RELEASE})

########### COMPONENT xtst VARIABLES #############################################

set(xorg_xtst_INCLUDE_DIRS_RELEASE )
set(xorg_xtst_INCLUDE_DIR_RELEASE "")
set(xorg_xtst_INCLUDES_RELEASE )
set(xorg_xtst_LIB_DIRS_RELEASE )
set(xorg_xtst_RES_DIRS_RELEASE )
set(xorg_xtst_DEFINITIONS_RELEASE )
set(xorg_xtst_COMPILE_DEFINITIONS_RELEASE )
set(xorg_xtst_COMPILE_OPTIONS_C_RELEASE "")
set(xorg_xtst_COMPILE_OPTIONS_CXX_RELEASE "")
set(xorg_xtst_LIBS_RELEASE )
set(xorg_xtst_SYSTEM_LIBS_RELEASE Xtst)
set(xorg_xtst_FRAMEWORK_DIRS_RELEASE )
set(xorg_xtst_FRAMEWORKS_RELEASE )
set(xorg_xtst_BUILD_MODULES_PATHS_RELEASE )
set(xorg_xtst_DEPENDENCIES_RELEASE )
set(xorg_xtst_LINKER_FLAGS_LIST_RELEASE
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>
)

########## COMPONENT xtst FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(xorg_xtst_FRAMEWORKS_FOUND_RELEASE "")
conan_find_apple_frameworks(xorg_xtst_FRAMEWORKS_FOUND_RELEASE "${xorg_xtst_FRAMEWORKS_RELEASE}" "${xorg_xtst_FRAMEWORK_DIRS_RELEASE}")

set(xorg_xtst_LIB_TARGETS_RELEASE "")
set(xorg_xtst_NOT_USED_RELEASE "")
set(xorg_xtst_LIBS_FRAMEWORKS_DEPS_RELEASE ${xorg_xtst_FRAMEWORKS_FOUND_RELEASE} ${xorg_xtst_SYSTEM_LIBS_RELEASE} ${xorg_xtst_DEPENDENCIES_RELEASE})
conan_package_library_targets("${xorg_xtst_LIBS_RELEASE}"
                              "${xorg_xtst_LIB_DIRS_RELEASE}"
                              "${xorg_xtst_LIBS_FRAMEWORKS_DEPS_RELEASE}"
                              xorg_xtst_NOT_USED_RELEASE
                              xorg_xtst_LIB_TARGETS_RELEASE
                              "RELEASE"
                              "xorg_xtst")

set(xorg_xtst_LINK_LIBS_RELEASE ${xorg_xtst_LIB_TARGETS_RELEASE} ${xorg_xtst_LIBS_FRAMEWORKS_DEPS_RELEASE})

########### COMPONENT xt VARIABLES #############################################

set(xorg_xt_INCLUDE_DIRS_RELEASE )
set(xorg_xt_INCLUDE_DIR_RELEASE "")
set(xorg_xt_INCLUDES_RELEASE )
set(xorg_xt_LIB_DIRS_RELEASE )
set(xorg_xt_RES_DIRS_RELEASE )
set(xorg_xt_DEFINITIONS_RELEASE )
set(xorg_xt_COMPILE_DEFINITIONS_RELEASE )
set(xorg_xt_COMPILE_OPTIONS_C_RELEASE "")
set(xorg_xt_COMPILE_OPTIONS_CXX_RELEASE "")
set(xorg_xt_LIBS_RELEASE )
set(xorg_xt_SYSTEM_LIBS_RELEASE Xt X11)
set(xorg_xt_FRAMEWORK_DIRS_RELEASE )
set(xorg_xt_FRAMEWORKS_RELEASE )
set(xorg_xt_BUILD_MODULES_PATHS_RELEASE )
set(xorg_xt_DEPENDENCIES_RELEASE )
set(xorg_xt_LINKER_FLAGS_LIST_RELEASE
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>
)

########## COMPONENT xt FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(xorg_xt_FRAMEWORKS_FOUND_RELEASE "")
conan_find_apple_frameworks(xorg_xt_FRAMEWORKS_FOUND_RELEASE "${xorg_xt_FRAMEWORKS_RELEASE}" "${xorg_xt_FRAMEWORK_DIRS_RELEASE}")

set(xorg_xt_LIB_TARGETS_RELEASE "")
set(xorg_xt_NOT_USED_RELEASE "")
set(xorg_xt_LIBS_FRAMEWORKS_DEPS_RELEASE ${xorg_xt_FRAMEWORKS_FOUND_RELEASE} ${xorg_xt_SYSTEM_LIBS_RELEASE} ${xorg_xt_DEPENDENCIES_RELEASE})
conan_package_library_targets("${xorg_xt_LIBS_RELEASE}"
                              "${xorg_xt_LIB_DIRS_RELEASE}"
                              "${xorg_xt_LIBS_FRAMEWORKS_DEPS_RELEASE}"
                              xorg_xt_NOT_USED_RELEASE
                              xorg_xt_LIB_TARGETS_RELEASE
                              "RELEASE"
                              "xorg_xt")

set(xorg_xt_LINK_LIBS_RELEASE ${xorg_xt_LIB_TARGETS_RELEASE} ${xorg_xt_LIBS_FRAMEWORKS_DEPS_RELEASE})

########### COMPONENT xscrnsaver VARIABLES #############################################

set(xorg_xscrnsaver_INCLUDE_DIRS_RELEASE )
set(xorg_xscrnsaver_INCLUDE_DIR_RELEASE "")
set(xorg_xscrnsaver_INCLUDES_RELEASE )
set(xorg_xscrnsaver_LIB_DIRS_RELEASE )
set(xorg_xscrnsaver_RES_DIRS_RELEASE )
set(xorg_xscrnsaver_DEFINITIONS_RELEASE )
set(xorg_xscrnsaver_COMPILE_DEFINITIONS_RELEASE )
set(xorg_xscrnsaver_COMPILE_OPTIONS_C_RELEASE "")
set(xorg_xscrnsaver_COMPILE_OPTIONS_CXX_RELEASE "")
set(xorg_xscrnsaver_LIBS_RELEASE )
set(xorg_xscrnsaver_SYSTEM_LIBS_RELEASE Xss)
set(xorg_xscrnsaver_FRAMEWORK_DIRS_RELEASE )
set(xorg_xscrnsaver_FRAMEWORKS_RELEASE )
set(xorg_xscrnsaver_BUILD_MODULES_PATHS_RELEASE )
set(xorg_xscrnsaver_DEPENDENCIES_RELEASE )
set(xorg_xscrnsaver_LINKER_FLAGS_LIST_RELEASE
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>
)

########## COMPONENT xscrnsaver FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(xorg_xscrnsaver_FRAMEWORKS_FOUND_RELEASE "")
conan_find_apple_frameworks(xorg_xscrnsaver_FRAMEWORKS_FOUND_RELEASE "${xorg_xscrnsaver_FRAMEWORKS_RELEASE}" "${xorg_xscrnsaver_FRAMEWORK_DIRS_RELEASE}")

set(xorg_xscrnsaver_LIB_TARGETS_RELEASE "")
set(xorg_xscrnsaver_NOT_USED_RELEASE "")
set(xorg_xscrnsaver_LIBS_FRAMEWORKS_DEPS_RELEASE ${xorg_xscrnsaver_FRAMEWORKS_FOUND_RELEASE} ${xorg_xscrnsaver_SYSTEM_LIBS_RELEASE} ${xorg_xscrnsaver_DEPENDENCIES_RELEASE})
conan_package_library_targets("${xorg_xscrnsaver_LIBS_RELEASE}"
                              "${xorg_xscrnsaver_LIB_DIRS_RELEASE}"
                              "${xorg_xscrnsaver_LIBS_FRAMEWORKS_DEPS_RELEASE}"
                              xorg_xscrnsaver_NOT_USED_RELEASE
                              xorg_xscrnsaver_LIB_TARGETS_RELEASE
                              "RELEASE"
                              "xorg_xscrnsaver")

set(xorg_xscrnsaver_LINK_LIBS_RELEASE ${xorg_xscrnsaver_LIB_TARGETS_RELEASE} ${xorg_xscrnsaver_LIBS_FRAMEWORKS_DEPS_RELEASE})

########### COMPONENT xres VARIABLES #############################################

set(xorg_xres_INCLUDE_DIRS_RELEASE )
set(xorg_xres_INCLUDE_DIR_RELEASE "")
set(xorg_xres_INCLUDES_RELEASE )
set(xorg_xres_LIB_DIRS_RELEASE )
set(xorg_xres_RES_DIRS_RELEASE )
set(xorg_xres_DEFINITIONS_RELEASE )
set(xorg_xres_COMPILE_DEFINITIONS_RELEASE )
set(xorg_xres_COMPILE_OPTIONS_C_RELEASE "")
set(xorg_xres_COMPILE_OPTIONS_CXX_RELEASE "")
set(xorg_xres_LIBS_RELEASE )
set(xorg_xres_SYSTEM_LIBS_RELEASE XRes)
set(xorg_xres_FRAMEWORK_DIRS_RELEASE )
set(xorg_xres_FRAMEWORKS_RELEASE )
set(xorg_xres_BUILD_MODULES_PATHS_RELEASE )
set(xorg_xres_DEPENDENCIES_RELEASE )
set(xorg_xres_LINKER_FLAGS_LIST_RELEASE
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>
)

########## COMPONENT xres FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(xorg_xres_FRAMEWORKS_FOUND_RELEASE "")
conan_find_apple_frameworks(xorg_xres_FRAMEWORKS_FOUND_RELEASE "${xorg_xres_FRAMEWORKS_RELEASE}" "${xorg_xres_FRAMEWORK_DIRS_RELEASE}")

set(xorg_xres_LIB_TARGETS_RELEASE "")
set(xorg_xres_NOT_USED_RELEASE "")
set(xorg_xres_LIBS_FRAMEWORKS_DEPS_RELEASE ${xorg_xres_FRAMEWORKS_FOUND_RELEASE} ${xorg_xres_SYSTEM_LIBS_RELEASE} ${xorg_xres_DEPENDENCIES_RELEASE})
conan_package_library_targets("${xorg_xres_LIBS_RELEASE}"
                              "${xorg_xres_LIB_DIRS_RELEASE}"
                              "${xorg_xres_LIBS_FRAMEWORKS_DEPS_RELEASE}"
                              xorg_xres_NOT_USED_RELEASE
                              xorg_xres_LIB_TARGETS_RELEASE
                              "RELEASE"
                              "xorg_xres")

set(xorg_xres_LINK_LIBS_RELEASE ${xorg_xres_LIB_TARGETS_RELEASE} ${xorg_xres_LIBS_FRAMEWORKS_DEPS_RELEASE})

########### COMPONENT xrender VARIABLES #############################################

set(xorg_xrender_INCLUDE_DIRS_RELEASE )
set(xorg_xrender_INCLUDE_DIR_RELEASE "")
set(xorg_xrender_INCLUDES_RELEASE )
set(xorg_xrender_LIB_DIRS_RELEASE )
set(xorg_xrender_RES_DIRS_RELEASE )
set(xorg_xrender_DEFINITIONS_RELEASE )
set(xorg_xrender_COMPILE_DEFINITIONS_RELEASE )
set(xorg_xrender_COMPILE_OPTIONS_C_RELEASE "")
set(xorg_xrender_COMPILE_OPTIONS_CXX_RELEASE "")
set(xorg_xrender_LIBS_RELEASE )
set(xorg_xrender_SYSTEM_LIBS_RELEASE Xrender X11)
set(xorg_xrender_FRAMEWORK_DIRS_RELEASE )
set(xorg_xrender_FRAMEWORKS_RELEASE )
set(xorg_xrender_BUILD_MODULES_PATHS_RELEASE )
set(xorg_xrender_DEPENDENCIES_RELEASE )
set(xorg_xrender_LINKER_FLAGS_LIST_RELEASE
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>
)

########## COMPONENT xrender FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(xorg_xrender_FRAMEWORKS_FOUND_RELEASE "")
conan_find_apple_frameworks(xorg_xrender_FRAMEWORKS_FOUND_RELEASE "${xorg_xrender_FRAMEWORKS_RELEASE}" "${xorg_xrender_FRAMEWORK_DIRS_RELEASE}")

set(xorg_xrender_LIB_TARGETS_RELEASE "")
set(xorg_xrender_NOT_USED_RELEASE "")
set(xorg_xrender_LIBS_FRAMEWORKS_DEPS_RELEASE ${xorg_xrender_FRAMEWORKS_FOUND_RELEASE} ${xorg_xrender_SYSTEM_LIBS_RELEASE} ${xorg_xrender_DEPENDENCIES_RELEASE})
conan_package_library_targets("${xorg_xrender_LIBS_RELEASE}"
                              "${xorg_xrender_LIB_DIRS_RELEASE}"
                              "${xorg_xrender_LIBS_FRAMEWORKS_DEPS_RELEASE}"
                              xorg_xrender_NOT_USED_RELEASE
                              xorg_xrender_LIB_TARGETS_RELEASE
                              "RELEASE"
                              "xorg_xrender")

set(xorg_xrender_LINK_LIBS_RELEASE ${xorg_xrender_LIB_TARGETS_RELEASE} ${xorg_xrender_LIBS_FRAMEWORKS_DEPS_RELEASE})

########### COMPONENT xrandr VARIABLES #############################################

set(xorg_xrandr_INCLUDE_DIRS_RELEASE )
set(xorg_xrandr_INCLUDE_DIR_RELEASE "")
set(xorg_xrandr_INCLUDES_RELEASE )
set(xorg_xrandr_LIB_DIRS_RELEASE )
set(xorg_xrandr_RES_DIRS_RELEASE )
set(xorg_xrandr_DEFINITIONS_RELEASE )
set(xorg_xrandr_COMPILE_DEFINITIONS_RELEASE )
set(xorg_xrandr_COMPILE_OPTIONS_C_RELEASE "")
set(xorg_xrandr_COMPILE_OPTIONS_CXX_RELEASE "")
set(xorg_xrandr_LIBS_RELEASE )
set(xorg_xrandr_SYSTEM_LIBS_RELEASE Xrandr)
set(xorg_xrandr_FRAMEWORK_DIRS_RELEASE )
set(xorg_xrandr_FRAMEWORKS_RELEASE )
set(xorg_xrandr_BUILD_MODULES_PATHS_RELEASE )
set(xorg_xrandr_DEPENDENCIES_RELEASE )
set(xorg_xrandr_LINKER_FLAGS_LIST_RELEASE
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>
)

########## COMPONENT xrandr FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(xorg_xrandr_FRAMEWORKS_FOUND_RELEASE "")
conan_find_apple_frameworks(xorg_xrandr_FRAMEWORKS_FOUND_RELEASE "${xorg_xrandr_FRAMEWORKS_RELEASE}" "${xorg_xrandr_FRAMEWORK_DIRS_RELEASE}")

set(xorg_xrandr_LIB_TARGETS_RELEASE "")
set(xorg_xrandr_NOT_USED_RELEASE "")
set(xorg_xrandr_LIBS_FRAMEWORKS_DEPS_RELEASE ${xorg_xrandr_FRAMEWORKS_FOUND_RELEASE} ${xorg_xrandr_SYSTEM_LIBS_RELEASE} ${xorg_xrandr_DEPENDENCIES_RELEASE})
conan_package_library_targets("${xorg_xrandr_LIBS_RELEASE}"
                              "${xorg_xrandr_LIB_DIRS_RELEASE}"
                              "${xorg_xrandr_LIBS_FRAMEWORKS_DEPS_RELEASE}"
                              xorg_xrandr_NOT_USED_RELEASE
                              xorg_xrandr_LIB_TARGETS_RELEASE
                              "RELEASE"
                              "xorg_xrandr")

set(xorg_xrandr_LINK_LIBS_RELEASE ${xorg_xrandr_LIB_TARGETS_RELEASE} ${xorg_xrandr_LIBS_FRAMEWORKS_DEPS_RELEASE})

########### COMPONENT xpm VARIABLES #############################################

set(xorg_xpm_INCLUDE_DIRS_RELEASE )
set(xorg_xpm_INCLUDE_DIR_RELEASE "")
set(xorg_xpm_INCLUDES_RELEASE )
set(xorg_xpm_LIB_DIRS_RELEASE )
set(xorg_xpm_RES_DIRS_RELEASE )
set(xorg_xpm_DEFINITIONS_RELEASE )
set(xorg_xpm_COMPILE_DEFINITIONS_RELEASE )
set(xorg_xpm_COMPILE_OPTIONS_C_RELEASE "")
set(xorg_xpm_COMPILE_OPTIONS_CXX_RELEASE "")
set(xorg_xpm_LIBS_RELEASE )
set(xorg_xpm_SYSTEM_LIBS_RELEASE Xpm X11)
set(xorg_xpm_FRAMEWORK_DIRS_RELEASE )
set(xorg_xpm_FRAMEWORKS_RELEASE )
set(xorg_xpm_BUILD_MODULES_PATHS_RELEASE )
set(xorg_xpm_DEPENDENCIES_RELEASE )
set(xorg_xpm_LINKER_FLAGS_LIST_RELEASE
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>
)

########## COMPONENT xpm FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(xorg_xpm_FRAMEWORKS_FOUND_RELEASE "")
conan_find_apple_frameworks(xorg_xpm_FRAMEWORKS_FOUND_RELEASE "${xorg_xpm_FRAMEWORKS_RELEASE}" "${xorg_xpm_FRAMEWORK_DIRS_RELEASE}")

set(xorg_xpm_LIB_TARGETS_RELEASE "")
set(xorg_xpm_NOT_USED_RELEASE "")
set(xorg_xpm_LIBS_FRAMEWORKS_DEPS_RELEASE ${xorg_xpm_FRAMEWORKS_FOUND_RELEASE} ${xorg_xpm_SYSTEM_LIBS_RELEASE} ${xorg_xpm_DEPENDENCIES_RELEASE})
conan_package_library_targets("${xorg_xpm_LIBS_RELEASE}"
                              "${xorg_xpm_LIB_DIRS_RELEASE}"
                              "${xorg_xpm_LIBS_FRAMEWORKS_DEPS_RELEASE}"
                              xorg_xpm_NOT_USED_RELEASE
                              xorg_xpm_LIB_TARGETS_RELEASE
                              "RELEASE"
                              "xorg_xpm")

set(xorg_xpm_LINK_LIBS_RELEASE ${xorg_xpm_LIB_TARGETS_RELEASE} ${xorg_xpm_LIBS_FRAMEWORKS_DEPS_RELEASE})

########### COMPONENT xmuu VARIABLES #############################################

set(xorg_xmuu_INCLUDE_DIRS_RELEASE )
set(xorg_xmuu_INCLUDE_DIR_RELEASE "")
set(xorg_xmuu_INCLUDES_RELEASE )
set(xorg_xmuu_LIB_DIRS_RELEASE )
set(xorg_xmuu_RES_DIRS_RELEASE )
set(xorg_xmuu_DEFINITIONS_RELEASE )
set(xorg_xmuu_COMPILE_DEFINITIONS_RELEASE )
set(xorg_xmuu_COMPILE_OPTIONS_C_RELEASE "")
set(xorg_xmuu_COMPILE_OPTIONS_CXX_RELEASE "")
set(xorg_xmuu_LIBS_RELEASE )
set(xorg_xmuu_SYSTEM_LIBS_RELEASE Xmuu)
set(xorg_xmuu_FRAMEWORK_DIRS_RELEASE )
set(xorg_xmuu_FRAMEWORKS_RELEASE )
set(xorg_xmuu_BUILD_MODULES_PATHS_RELEASE )
set(xorg_xmuu_DEPENDENCIES_RELEASE )
set(xorg_xmuu_LINKER_FLAGS_LIST_RELEASE
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>
)

########## COMPONENT xmuu FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(xorg_xmuu_FRAMEWORKS_FOUND_RELEASE "")
conan_find_apple_frameworks(xorg_xmuu_FRAMEWORKS_FOUND_RELEASE "${xorg_xmuu_FRAMEWORKS_RELEASE}" "${xorg_xmuu_FRAMEWORK_DIRS_RELEASE}")

set(xorg_xmuu_LIB_TARGETS_RELEASE "")
set(xorg_xmuu_NOT_USED_RELEASE "")
set(xorg_xmuu_LIBS_FRAMEWORKS_DEPS_RELEASE ${xorg_xmuu_FRAMEWORKS_FOUND_RELEASE} ${xorg_xmuu_SYSTEM_LIBS_RELEASE} ${xorg_xmuu_DEPENDENCIES_RELEASE})
conan_package_library_targets("${xorg_xmuu_LIBS_RELEASE}"
                              "${xorg_xmuu_LIB_DIRS_RELEASE}"
                              "${xorg_xmuu_LIBS_FRAMEWORKS_DEPS_RELEASE}"
                              xorg_xmuu_NOT_USED_RELEASE
                              xorg_xmuu_LIB_TARGETS_RELEASE
                              "RELEASE"
                              "xorg_xmuu")

set(xorg_xmuu_LINK_LIBS_RELEASE ${xorg_xmuu_LIB_TARGETS_RELEASE} ${xorg_xmuu_LIBS_FRAMEWORKS_DEPS_RELEASE})

########### COMPONENT xmu VARIABLES #############################################

set(xorg_xmu_INCLUDE_DIRS_RELEASE )
set(xorg_xmu_INCLUDE_DIR_RELEASE "")
set(xorg_xmu_INCLUDES_RELEASE )
set(xorg_xmu_LIB_DIRS_RELEASE )
set(xorg_xmu_RES_DIRS_RELEASE )
set(xorg_xmu_DEFINITIONS_RELEASE )
set(xorg_xmu_COMPILE_DEFINITIONS_RELEASE )
set(xorg_xmu_COMPILE_OPTIONS_C_RELEASE "")
set(xorg_xmu_COMPILE_OPTIONS_CXX_RELEASE "")
set(xorg_xmu_LIBS_RELEASE )
set(xorg_xmu_SYSTEM_LIBS_RELEASE Xmu Xt X11)
set(xorg_xmu_FRAMEWORK_DIRS_RELEASE )
set(xorg_xmu_FRAMEWORKS_RELEASE )
set(xorg_xmu_BUILD_MODULES_PATHS_RELEASE )
set(xorg_xmu_DEPENDENCIES_RELEASE )
set(xorg_xmu_LINKER_FLAGS_LIST_RELEASE
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>
)

########## COMPONENT xmu FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(xorg_xmu_FRAMEWORKS_FOUND_RELEASE "")
conan_find_apple_frameworks(xorg_xmu_FRAMEWORKS_FOUND_RELEASE "${xorg_xmu_FRAMEWORKS_RELEASE}" "${xorg_xmu_FRAMEWORK_DIRS_RELEASE}")

set(xorg_xmu_LIB_TARGETS_RELEASE "")
set(xorg_xmu_NOT_USED_RELEASE "")
set(xorg_xmu_LIBS_FRAMEWORKS_DEPS_RELEASE ${xorg_xmu_FRAMEWORKS_FOUND_RELEASE} ${xorg_xmu_SYSTEM_LIBS_RELEASE} ${xorg_xmu_DEPENDENCIES_RELEASE})
conan_package_library_targets("${xorg_xmu_LIBS_RELEASE}"
                              "${xorg_xmu_LIB_DIRS_RELEASE}"
                              "${xorg_xmu_LIBS_FRAMEWORKS_DEPS_RELEASE}"
                              xorg_xmu_NOT_USED_RELEASE
                              xorg_xmu_LIB_TARGETS_RELEASE
                              "RELEASE"
                              "xorg_xmu")

set(xorg_xmu_LINK_LIBS_RELEASE ${xorg_xmu_LIB_TARGETS_RELEASE} ${xorg_xmu_LIBS_FRAMEWORKS_DEPS_RELEASE})

########### COMPONENT xkbfile VARIABLES #############################################

set(xorg_xkbfile_INCLUDE_DIRS_RELEASE )
set(xorg_xkbfile_INCLUDE_DIR_RELEASE "")
set(xorg_xkbfile_INCLUDES_RELEASE )
set(xorg_xkbfile_LIB_DIRS_RELEASE )
set(xorg_xkbfile_RES_DIRS_RELEASE )
set(xorg_xkbfile_DEFINITIONS_RELEASE )
set(xorg_xkbfile_COMPILE_DEFINITIONS_RELEASE )
set(xorg_xkbfile_COMPILE_OPTIONS_C_RELEASE "")
set(xorg_xkbfile_COMPILE_OPTIONS_CXX_RELEASE "")
set(xorg_xkbfile_LIBS_RELEASE )
set(xorg_xkbfile_SYSTEM_LIBS_RELEASE xkbfile)
set(xorg_xkbfile_FRAMEWORK_DIRS_RELEASE )
set(xorg_xkbfile_FRAMEWORKS_RELEASE )
set(xorg_xkbfile_BUILD_MODULES_PATHS_RELEASE )
set(xorg_xkbfile_DEPENDENCIES_RELEASE )
set(xorg_xkbfile_LINKER_FLAGS_LIST_RELEASE
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>
)

########## COMPONENT xkbfile FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(xorg_xkbfile_FRAMEWORKS_FOUND_RELEASE "")
conan_find_apple_frameworks(xorg_xkbfile_FRAMEWORKS_FOUND_RELEASE "${xorg_xkbfile_FRAMEWORKS_RELEASE}" "${xorg_xkbfile_FRAMEWORK_DIRS_RELEASE}")

set(xorg_xkbfile_LIB_TARGETS_RELEASE "")
set(xorg_xkbfile_NOT_USED_RELEASE "")
set(xorg_xkbfile_LIBS_FRAMEWORKS_DEPS_RELEASE ${xorg_xkbfile_FRAMEWORKS_FOUND_RELEASE} ${xorg_xkbfile_SYSTEM_LIBS_RELEASE} ${xorg_xkbfile_DEPENDENCIES_RELEASE})
conan_package_library_targets("${xorg_xkbfile_LIBS_RELEASE}"
                              "${xorg_xkbfile_LIB_DIRS_RELEASE}"
                              "${xorg_xkbfile_LIBS_FRAMEWORKS_DEPS_RELEASE}"
                              xorg_xkbfile_NOT_USED_RELEASE
                              xorg_xkbfile_LIB_TARGETS_RELEASE
                              "RELEASE"
                              "xorg_xkbfile")

set(xorg_xkbfile_LINK_LIBS_RELEASE ${xorg_xkbfile_LIB_TARGETS_RELEASE} ${xorg_xkbfile_LIBS_FRAMEWORKS_DEPS_RELEASE})

########### COMPONENT xinerama VARIABLES #############################################

set(xorg_xinerama_INCLUDE_DIRS_RELEASE )
set(xorg_xinerama_INCLUDE_DIR_RELEASE "")
set(xorg_xinerama_INCLUDES_RELEASE )
set(xorg_xinerama_LIB_DIRS_RELEASE )
set(xorg_xinerama_RES_DIRS_RELEASE )
set(xorg_xinerama_DEFINITIONS_RELEASE )
set(xorg_xinerama_COMPILE_DEFINITIONS_RELEASE )
set(xorg_xinerama_COMPILE_OPTIONS_C_RELEASE "")
set(xorg_xinerama_COMPILE_OPTIONS_CXX_RELEASE "")
set(xorg_xinerama_LIBS_RELEASE )
set(xorg_xinerama_SYSTEM_LIBS_RELEASE Xinerama)
set(xorg_xinerama_FRAMEWORK_DIRS_RELEASE )
set(xorg_xinerama_FRAMEWORKS_RELEASE )
set(xorg_xinerama_BUILD_MODULES_PATHS_RELEASE )
set(xorg_xinerama_DEPENDENCIES_RELEASE )
set(xorg_xinerama_LINKER_FLAGS_LIST_RELEASE
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>
)

########## COMPONENT xinerama FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(xorg_xinerama_FRAMEWORKS_FOUND_RELEASE "")
conan_find_apple_frameworks(xorg_xinerama_FRAMEWORKS_FOUND_RELEASE "${xorg_xinerama_FRAMEWORKS_RELEASE}" "${xorg_xinerama_FRAMEWORK_DIRS_RELEASE}")

set(xorg_xinerama_LIB_TARGETS_RELEASE "")
set(xorg_xinerama_NOT_USED_RELEASE "")
set(xorg_xinerama_LIBS_FRAMEWORKS_DEPS_RELEASE ${xorg_xinerama_FRAMEWORKS_FOUND_RELEASE} ${xorg_xinerama_SYSTEM_LIBS_RELEASE} ${xorg_xinerama_DEPENDENCIES_RELEASE})
conan_package_library_targets("${xorg_xinerama_LIBS_RELEASE}"
                              "${xorg_xinerama_LIB_DIRS_RELEASE}"
                              "${xorg_xinerama_LIBS_FRAMEWORKS_DEPS_RELEASE}"
                              xorg_xinerama_NOT_USED_RELEASE
                              xorg_xinerama_LIB_TARGETS_RELEASE
                              "RELEASE"
                              "xorg_xinerama")

set(xorg_xinerama_LINK_LIBS_RELEASE ${xorg_xinerama_LIB_TARGETS_RELEASE} ${xorg_xinerama_LIBS_FRAMEWORKS_DEPS_RELEASE})

########### COMPONENT xi VARIABLES #############################################

set(xorg_xi_INCLUDE_DIRS_RELEASE )
set(xorg_xi_INCLUDE_DIR_RELEASE "")
set(xorg_xi_INCLUDES_RELEASE )
set(xorg_xi_LIB_DIRS_RELEASE )
set(xorg_xi_RES_DIRS_RELEASE )
set(xorg_xi_DEFINITIONS_RELEASE )
set(xorg_xi_COMPILE_DEFINITIONS_RELEASE )
set(xorg_xi_COMPILE_OPTIONS_C_RELEASE "")
set(xorg_xi_COMPILE_OPTIONS_CXX_RELEASE "")
set(xorg_xi_LIBS_RELEASE )
set(xorg_xi_SYSTEM_LIBS_RELEASE Xi)
set(xorg_xi_FRAMEWORK_DIRS_RELEASE )
set(xorg_xi_FRAMEWORKS_RELEASE )
set(xorg_xi_BUILD_MODULES_PATHS_RELEASE )
set(xorg_xi_DEPENDENCIES_RELEASE )
set(xorg_xi_LINKER_FLAGS_LIST_RELEASE
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>
)

########## COMPONENT xi FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(xorg_xi_FRAMEWORKS_FOUND_RELEASE "")
conan_find_apple_frameworks(xorg_xi_FRAMEWORKS_FOUND_RELEASE "${xorg_xi_FRAMEWORKS_RELEASE}" "${xorg_xi_FRAMEWORK_DIRS_RELEASE}")

set(xorg_xi_LIB_TARGETS_RELEASE "")
set(xorg_xi_NOT_USED_RELEASE "")
set(xorg_xi_LIBS_FRAMEWORKS_DEPS_RELEASE ${xorg_xi_FRAMEWORKS_FOUND_RELEASE} ${xorg_xi_SYSTEM_LIBS_RELEASE} ${xorg_xi_DEPENDENCIES_RELEASE})
conan_package_library_targets("${xorg_xi_LIBS_RELEASE}"
                              "${xorg_xi_LIB_DIRS_RELEASE}"
                              "${xorg_xi_LIBS_FRAMEWORKS_DEPS_RELEASE}"
                              xorg_xi_NOT_USED_RELEASE
                              xorg_xi_LIB_TARGETS_RELEASE
                              "RELEASE"
                              "xorg_xi")

set(xorg_xi_LINK_LIBS_RELEASE ${xorg_xi_LIB_TARGETS_RELEASE} ${xorg_xi_LIBS_FRAMEWORKS_DEPS_RELEASE})

########### COMPONENT xft VARIABLES #############################################

set(xorg_xft_INCLUDE_DIRS_RELEASE "/usr/include/uuid"
			"/usr/include/freetype2"
			"/usr/include/libpng16")
set(xorg_xft_INCLUDE_DIR_RELEASE "/usr/include/uuid;/usr/include/freetype2;/usr/include/libpng16")
set(xorg_xft_INCLUDES_RELEASE "/usr/include/uuid"
			"/usr/include/freetype2"
			"/usr/include/libpng16")
set(xorg_xft_LIB_DIRS_RELEASE )
set(xorg_xft_RES_DIRS_RELEASE )
set(xorg_xft_DEFINITIONS_RELEASE )
set(xorg_xft_COMPILE_DEFINITIONS_RELEASE )
set(xorg_xft_COMPILE_OPTIONS_C_RELEASE "")
set(xorg_xft_COMPILE_OPTIONS_CXX_RELEASE "")
set(xorg_xft_LIBS_RELEASE )
set(xorg_xft_SYSTEM_LIBS_RELEASE Xft)
set(xorg_xft_FRAMEWORK_DIRS_RELEASE )
set(xorg_xft_FRAMEWORKS_RELEASE )
set(xorg_xft_BUILD_MODULES_PATHS_RELEASE )
set(xorg_xft_DEPENDENCIES_RELEASE )
set(xorg_xft_LINKER_FLAGS_LIST_RELEASE
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>
)

########## COMPONENT xft FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(xorg_xft_FRAMEWORKS_FOUND_RELEASE "")
conan_find_apple_frameworks(xorg_xft_FRAMEWORKS_FOUND_RELEASE "${xorg_xft_FRAMEWORKS_RELEASE}" "${xorg_xft_FRAMEWORK_DIRS_RELEASE}")

set(xorg_xft_LIB_TARGETS_RELEASE "")
set(xorg_xft_NOT_USED_RELEASE "")
set(xorg_xft_LIBS_FRAMEWORKS_DEPS_RELEASE ${xorg_xft_FRAMEWORKS_FOUND_RELEASE} ${xorg_xft_SYSTEM_LIBS_RELEASE} ${xorg_xft_DEPENDENCIES_RELEASE})
conan_package_library_targets("${xorg_xft_LIBS_RELEASE}"
                              "${xorg_xft_LIB_DIRS_RELEASE}"
                              "${xorg_xft_LIBS_FRAMEWORKS_DEPS_RELEASE}"
                              xorg_xft_NOT_USED_RELEASE
                              xorg_xft_LIB_TARGETS_RELEASE
                              "RELEASE"
                              "xorg_xft")

set(xorg_xft_LINK_LIBS_RELEASE ${xorg_xft_LIB_TARGETS_RELEASE} ${xorg_xft_LIBS_FRAMEWORKS_DEPS_RELEASE})

########### COMPONENT xfixes VARIABLES #############################################

set(xorg_xfixes_INCLUDE_DIRS_RELEASE )
set(xorg_xfixes_INCLUDE_DIR_RELEASE "")
set(xorg_xfixes_INCLUDES_RELEASE )
set(xorg_xfixes_LIB_DIRS_RELEASE )
set(xorg_xfixes_RES_DIRS_RELEASE )
set(xorg_xfixes_DEFINITIONS_RELEASE )
set(xorg_xfixes_COMPILE_DEFINITIONS_RELEASE )
set(xorg_xfixes_COMPILE_OPTIONS_C_RELEASE "")
set(xorg_xfixes_COMPILE_OPTIONS_CXX_RELEASE "")
set(xorg_xfixes_LIBS_RELEASE )
set(xorg_xfixes_SYSTEM_LIBS_RELEASE Xfixes)
set(xorg_xfixes_FRAMEWORK_DIRS_RELEASE )
set(xorg_xfixes_FRAMEWORKS_RELEASE )
set(xorg_xfixes_BUILD_MODULES_PATHS_RELEASE )
set(xorg_xfixes_DEPENDENCIES_RELEASE )
set(xorg_xfixes_LINKER_FLAGS_LIST_RELEASE
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>
)

########## COMPONENT xfixes FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(xorg_xfixes_FRAMEWORKS_FOUND_RELEASE "")
conan_find_apple_frameworks(xorg_xfixes_FRAMEWORKS_FOUND_RELEASE "${xorg_xfixes_FRAMEWORKS_RELEASE}" "${xorg_xfixes_FRAMEWORK_DIRS_RELEASE}")

set(xorg_xfixes_LIB_TARGETS_RELEASE "")
set(xorg_xfixes_NOT_USED_RELEASE "")
set(xorg_xfixes_LIBS_FRAMEWORKS_DEPS_RELEASE ${xorg_xfixes_FRAMEWORKS_FOUND_RELEASE} ${xorg_xfixes_SYSTEM_LIBS_RELEASE} ${xorg_xfixes_DEPENDENCIES_RELEASE})
conan_package_library_targets("${xorg_xfixes_LIBS_RELEASE}"
                              "${xorg_xfixes_LIB_DIRS_RELEASE}"
                              "${xorg_xfixes_LIBS_FRAMEWORKS_DEPS_RELEASE}"
                              xorg_xfixes_NOT_USED_RELEASE
                              xorg_xfixes_LIB_TARGETS_RELEASE
                              "RELEASE"
                              "xorg_xfixes")

set(xorg_xfixes_LINK_LIBS_RELEASE ${xorg_xfixes_LIB_TARGETS_RELEASE} ${xorg_xfixes_LIBS_FRAMEWORKS_DEPS_RELEASE})

########### COMPONENT xext VARIABLES #############################################

set(xorg_xext_INCLUDE_DIRS_RELEASE )
set(xorg_xext_INCLUDE_DIR_RELEASE "")
set(xorg_xext_INCLUDES_RELEASE )
set(xorg_xext_LIB_DIRS_RELEASE )
set(xorg_xext_RES_DIRS_RELEASE )
set(xorg_xext_DEFINITIONS_RELEASE )
set(xorg_xext_COMPILE_DEFINITIONS_RELEASE )
set(xorg_xext_COMPILE_OPTIONS_C_RELEASE "")
set(xorg_xext_COMPILE_OPTIONS_CXX_RELEASE "")
set(xorg_xext_LIBS_RELEASE )
set(xorg_xext_SYSTEM_LIBS_RELEASE Xext)
set(xorg_xext_FRAMEWORK_DIRS_RELEASE )
set(xorg_xext_FRAMEWORKS_RELEASE )
set(xorg_xext_BUILD_MODULES_PATHS_RELEASE )
set(xorg_xext_DEPENDENCIES_RELEASE )
set(xorg_xext_LINKER_FLAGS_LIST_RELEASE
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>
)

########## COMPONENT xext FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(xorg_xext_FRAMEWORKS_FOUND_RELEASE "")
conan_find_apple_frameworks(xorg_xext_FRAMEWORKS_FOUND_RELEASE "${xorg_xext_FRAMEWORKS_RELEASE}" "${xorg_xext_FRAMEWORK_DIRS_RELEASE}")

set(xorg_xext_LIB_TARGETS_RELEASE "")
set(xorg_xext_NOT_USED_RELEASE "")
set(xorg_xext_LIBS_FRAMEWORKS_DEPS_RELEASE ${xorg_xext_FRAMEWORKS_FOUND_RELEASE} ${xorg_xext_SYSTEM_LIBS_RELEASE} ${xorg_xext_DEPENDENCIES_RELEASE})
conan_package_library_targets("${xorg_xext_LIBS_RELEASE}"
                              "${xorg_xext_LIB_DIRS_RELEASE}"
                              "${xorg_xext_LIBS_FRAMEWORKS_DEPS_RELEASE}"
                              xorg_xext_NOT_USED_RELEASE
                              xorg_xext_LIB_TARGETS_RELEASE
                              "RELEASE"
                              "xorg_xext")

set(xorg_xext_LINK_LIBS_RELEASE ${xorg_xext_LIB_TARGETS_RELEASE} ${xorg_xext_LIBS_FRAMEWORKS_DEPS_RELEASE})

########### COMPONENT xdmcp VARIABLES #############################################

set(xorg_xdmcp_INCLUDE_DIRS_RELEASE )
set(xorg_xdmcp_INCLUDE_DIR_RELEASE "")
set(xorg_xdmcp_INCLUDES_RELEASE )
set(xorg_xdmcp_LIB_DIRS_RELEASE )
set(xorg_xdmcp_RES_DIRS_RELEASE )
set(xorg_xdmcp_DEFINITIONS_RELEASE )
set(xorg_xdmcp_COMPILE_DEFINITIONS_RELEASE )
set(xorg_xdmcp_COMPILE_OPTIONS_C_RELEASE "")
set(xorg_xdmcp_COMPILE_OPTIONS_CXX_RELEASE "")
set(xorg_xdmcp_LIBS_RELEASE )
set(xorg_xdmcp_SYSTEM_LIBS_RELEASE Xdmcp)
set(xorg_xdmcp_FRAMEWORK_DIRS_RELEASE )
set(xorg_xdmcp_FRAMEWORKS_RELEASE )
set(xorg_xdmcp_BUILD_MODULES_PATHS_RELEASE )
set(xorg_xdmcp_DEPENDENCIES_RELEASE )
set(xorg_xdmcp_LINKER_FLAGS_LIST_RELEASE
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>
)

########## COMPONENT xdmcp FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(xorg_xdmcp_FRAMEWORKS_FOUND_RELEASE "")
conan_find_apple_frameworks(xorg_xdmcp_FRAMEWORKS_FOUND_RELEASE "${xorg_xdmcp_FRAMEWORKS_RELEASE}" "${xorg_xdmcp_FRAMEWORK_DIRS_RELEASE}")

set(xorg_xdmcp_LIB_TARGETS_RELEASE "")
set(xorg_xdmcp_NOT_USED_RELEASE "")
set(xorg_xdmcp_LIBS_FRAMEWORKS_DEPS_RELEASE ${xorg_xdmcp_FRAMEWORKS_FOUND_RELEASE} ${xorg_xdmcp_SYSTEM_LIBS_RELEASE} ${xorg_xdmcp_DEPENDENCIES_RELEASE})
conan_package_library_targets("${xorg_xdmcp_LIBS_RELEASE}"
                              "${xorg_xdmcp_LIB_DIRS_RELEASE}"
                              "${xorg_xdmcp_LIBS_FRAMEWORKS_DEPS_RELEASE}"
                              xorg_xdmcp_NOT_USED_RELEASE
                              xorg_xdmcp_LIB_TARGETS_RELEASE
                              "RELEASE"
                              "xorg_xdmcp")

set(xorg_xdmcp_LINK_LIBS_RELEASE ${xorg_xdmcp_LIB_TARGETS_RELEASE} ${xorg_xdmcp_LIBS_FRAMEWORKS_DEPS_RELEASE})

########### COMPONENT xdamage VARIABLES #############################################

set(xorg_xdamage_INCLUDE_DIRS_RELEASE )
set(xorg_xdamage_INCLUDE_DIR_RELEASE "")
set(xorg_xdamage_INCLUDES_RELEASE )
set(xorg_xdamage_LIB_DIRS_RELEASE )
set(xorg_xdamage_RES_DIRS_RELEASE )
set(xorg_xdamage_DEFINITIONS_RELEASE )
set(xorg_xdamage_COMPILE_DEFINITIONS_RELEASE )
set(xorg_xdamage_COMPILE_OPTIONS_C_RELEASE "")
set(xorg_xdamage_COMPILE_OPTIONS_CXX_RELEASE "")
set(xorg_xdamage_LIBS_RELEASE )
set(xorg_xdamage_SYSTEM_LIBS_RELEASE Xdamage Xfixes)
set(xorg_xdamage_FRAMEWORK_DIRS_RELEASE )
set(xorg_xdamage_FRAMEWORKS_RELEASE )
set(xorg_xdamage_BUILD_MODULES_PATHS_RELEASE )
set(xorg_xdamage_DEPENDENCIES_RELEASE )
set(xorg_xdamage_LINKER_FLAGS_LIST_RELEASE
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>
)

########## COMPONENT xdamage FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(xorg_xdamage_FRAMEWORKS_FOUND_RELEASE "")
conan_find_apple_frameworks(xorg_xdamage_FRAMEWORKS_FOUND_RELEASE "${xorg_xdamage_FRAMEWORKS_RELEASE}" "${xorg_xdamage_FRAMEWORK_DIRS_RELEASE}")

set(xorg_xdamage_LIB_TARGETS_RELEASE "")
set(xorg_xdamage_NOT_USED_RELEASE "")
set(xorg_xdamage_LIBS_FRAMEWORKS_DEPS_RELEASE ${xorg_xdamage_FRAMEWORKS_FOUND_RELEASE} ${xorg_xdamage_SYSTEM_LIBS_RELEASE} ${xorg_xdamage_DEPENDENCIES_RELEASE})
conan_package_library_targets("${xorg_xdamage_LIBS_RELEASE}"
                              "${xorg_xdamage_LIB_DIRS_RELEASE}"
                              "${xorg_xdamage_LIBS_FRAMEWORKS_DEPS_RELEASE}"
                              xorg_xdamage_NOT_USED_RELEASE
                              xorg_xdamage_LIB_TARGETS_RELEASE
                              "RELEASE"
                              "xorg_xdamage")

set(xorg_xdamage_LINK_LIBS_RELEASE ${xorg_xdamage_LIB_TARGETS_RELEASE} ${xorg_xdamage_LIBS_FRAMEWORKS_DEPS_RELEASE})

########### COMPONENT xcursor VARIABLES #############################################

set(xorg_xcursor_INCLUDE_DIRS_RELEASE )
set(xorg_xcursor_INCLUDE_DIR_RELEASE "")
set(xorg_xcursor_INCLUDES_RELEASE )
set(xorg_xcursor_LIB_DIRS_RELEASE )
set(xorg_xcursor_RES_DIRS_RELEASE )
set(xorg_xcursor_DEFINITIONS_RELEASE )
set(xorg_xcursor_COMPILE_DEFINITIONS_RELEASE )
set(xorg_xcursor_COMPILE_OPTIONS_C_RELEASE "")
set(xorg_xcursor_COMPILE_OPTIONS_CXX_RELEASE "")
set(xorg_xcursor_LIBS_RELEASE )
set(xorg_xcursor_SYSTEM_LIBS_RELEASE Xcursor)
set(xorg_xcursor_FRAMEWORK_DIRS_RELEASE )
set(xorg_xcursor_FRAMEWORKS_RELEASE )
set(xorg_xcursor_BUILD_MODULES_PATHS_RELEASE )
set(xorg_xcursor_DEPENDENCIES_RELEASE )
set(xorg_xcursor_LINKER_FLAGS_LIST_RELEASE
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>
)

########## COMPONENT xcursor FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(xorg_xcursor_FRAMEWORKS_FOUND_RELEASE "")
conan_find_apple_frameworks(xorg_xcursor_FRAMEWORKS_FOUND_RELEASE "${xorg_xcursor_FRAMEWORKS_RELEASE}" "${xorg_xcursor_FRAMEWORK_DIRS_RELEASE}")

set(xorg_xcursor_LIB_TARGETS_RELEASE "")
set(xorg_xcursor_NOT_USED_RELEASE "")
set(xorg_xcursor_LIBS_FRAMEWORKS_DEPS_RELEASE ${xorg_xcursor_FRAMEWORKS_FOUND_RELEASE} ${xorg_xcursor_SYSTEM_LIBS_RELEASE} ${xorg_xcursor_DEPENDENCIES_RELEASE})
conan_package_library_targets("${xorg_xcursor_LIBS_RELEASE}"
                              "${xorg_xcursor_LIB_DIRS_RELEASE}"
                              "${xorg_xcursor_LIBS_FRAMEWORKS_DEPS_RELEASE}"
                              xorg_xcursor_NOT_USED_RELEASE
                              xorg_xcursor_LIB_TARGETS_RELEASE
                              "RELEASE"
                              "xorg_xcursor")

set(xorg_xcursor_LINK_LIBS_RELEASE ${xorg_xcursor_LIB_TARGETS_RELEASE} ${xorg_xcursor_LIBS_FRAMEWORKS_DEPS_RELEASE})

########### COMPONENT xcomposite VARIABLES #############################################

set(xorg_xcomposite_INCLUDE_DIRS_RELEASE )
set(xorg_xcomposite_INCLUDE_DIR_RELEASE "")
set(xorg_xcomposite_INCLUDES_RELEASE )
set(xorg_xcomposite_LIB_DIRS_RELEASE )
set(xorg_xcomposite_RES_DIRS_RELEASE )
set(xorg_xcomposite_DEFINITIONS_RELEASE )
set(xorg_xcomposite_COMPILE_DEFINITIONS_RELEASE )
set(xorg_xcomposite_COMPILE_OPTIONS_C_RELEASE "")
set(xorg_xcomposite_COMPILE_OPTIONS_CXX_RELEASE "")
set(xorg_xcomposite_LIBS_RELEASE )
set(xorg_xcomposite_SYSTEM_LIBS_RELEASE Xcomposite)
set(xorg_xcomposite_FRAMEWORK_DIRS_RELEASE )
set(xorg_xcomposite_FRAMEWORKS_RELEASE )
set(xorg_xcomposite_BUILD_MODULES_PATHS_RELEASE )
set(xorg_xcomposite_DEPENDENCIES_RELEASE )
set(xorg_xcomposite_LINKER_FLAGS_LIST_RELEASE
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>
)

########## COMPONENT xcomposite FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(xorg_xcomposite_FRAMEWORKS_FOUND_RELEASE "")
conan_find_apple_frameworks(xorg_xcomposite_FRAMEWORKS_FOUND_RELEASE "${xorg_xcomposite_FRAMEWORKS_RELEASE}" "${xorg_xcomposite_FRAMEWORK_DIRS_RELEASE}")

set(xorg_xcomposite_LIB_TARGETS_RELEASE "")
set(xorg_xcomposite_NOT_USED_RELEASE "")
set(xorg_xcomposite_LIBS_FRAMEWORKS_DEPS_RELEASE ${xorg_xcomposite_FRAMEWORKS_FOUND_RELEASE} ${xorg_xcomposite_SYSTEM_LIBS_RELEASE} ${xorg_xcomposite_DEPENDENCIES_RELEASE})
conan_package_library_targets("${xorg_xcomposite_LIBS_RELEASE}"
                              "${xorg_xcomposite_LIB_DIRS_RELEASE}"
                              "${xorg_xcomposite_LIBS_FRAMEWORKS_DEPS_RELEASE}"
                              xorg_xcomposite_NOT_USED_RELEASE
                              xorg_xcomposite_LIB_TARGETS_RELEASE
                              "RELEASE"
                              "xorg_xcomposite")

set(xorg_xcomposite_LINK_LIBS_RELEASE ${xorg_xcomposite_LIB_TARGETS_RELEASE} ${xorg_xcomposite_LIBS_FRAMEWORKS_DEPS_RELEASE})

########### COMPONENT xaw7 VARIABLES #############################################

set(xorg_xaw7_INCLUDE_DIRS_RELEASE )
set(xorg_xaw7_INCLUDE_DIR_RELEASE "")
set(xorg_xaw7_INCLUDES_RELEASE )
set(xorg_xaw7_LIB_DIRS_RELEASE )
set(xorg_xaw7_RES_DIRS_RELEASE )
set(xorg_xaw7_DEFINITIONS_RELEASE )
set(xorg_xaw7_COMPILE_DEFINITIONS_RELEASE )
set(xorg_xaw7_COMPILE_OPTIONS_C_RELEASE "")
set(xorg_xaw7_COMPILE_OPTIONS_CXX_RELEASE "")
set(xorg_xaw7_LIBS_RELEASE )
set(xorg_xaw7_SYSTEM_LIBS_RELEASE Xaw7 Xt X11)
set(xorg_xaw7_FRAMEWORK_DIRS_RELEASE )
set(xorg_xaw7_FRAMEWORKS_RELEASE )
set(xorg_xaw7_BUILD_MODULES_PATHS_RELEASE )
set(xorg_xaw7_DEPENDENCIES_RELEASE )
set(xorg_xaw7_LINKER_FLAGS_LIST_RELEASE
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>
)

########## COMPONENT xaw7 FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(xorg_xaw7_FRAMEWORKS_FOUND_RELEASE "")
conan_find_apple_frameworks(xorg_xaw7_FRAMEWORKS_FOUND_RELEASE "${xorg_xaw7_FRAMEWORKS_RELEASE}" "${xorg_xaw7_FRAMEWORK_DIRS_RELEASE}")

set(xorg_xaw7_LIB_TARGETS_RELEASE "")
set(xorg_xaw7_NOT_USED_RELEASE "")
set(xorg_xaw7_LIBS_FRAMEWORKS_DEPS_RELEASE ${xorg_xaw7_FRAMEWORKS_FOUND_RELEASE} ${xorg_xaw7_SYSTEM_LIBS_RELEASE} ${xorg_xaw7_DEPENDENCIES_RELEASE})
conan_package_library_targets("${xorg_xaw7_LIBS_RELEASE}"
                              "${xorg_xaw7_LIB_DIRS_RELEASE}"
                              "${xorg_xaw7_LIBS_FRAMEWORKS_DEPS_RELEASE}"
                              xorg_xaw7_NOT_USED_RELEASE
                              xorg_xaw7_LIB_TARGETS_RELEASE
                              "RELEASE"
                              "xorg_xaw7")

set(xorg_xaw7_LINK_LIBS_RELEASE ${xorg_xaw7_LIB_TARGETS_RELEASE} ${xorg_xaw7_LIBS_FRAMEWORKS_DEPS_RELEASE})

########### COMPONENT xau VARIABLES #############################################

set(xorg_xau_INCLUDE_DIRS_RELEASE )
set(xorg_xau_INCLUDE_DIR_RELEASE "")
set(xorg_xau_INCLUDES_RELEASE )
set(xorg_xau_LIB_DIRS_RELEASE )
set(xorg_xau_RES_DIRS_RELEASE )
set(xorg_xau_DEFINITIONS_RELEASE )
set(xorg_xau_COMPILE_DEFINITIONS_RELEASE )
set(xorg_xau_COMPILE_OPTIONS_C_RELEASE "")
set(xorg_xau_COMPILE_OPTIONS_CXX_RELEASE "")
set(xorg_xau_LIBS_RELEASE )
set(xorg_xau_SYSTEM_LIBS_RELEASE Xau)
set(xorg_xau_FRAMEWORK_DIRS_RELEASE )
set(xorg_xau_FRAMEWORKS_RELEASE )
set(xorg_xau_BUILD_MODULES_PATHS_RELEASE )
set(xorg_xau_DEPENDENCIES_RELEASE )
set(xorg_xau_LINKER_FLAGS_LIST_RELEASE
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>
)

########## COMPONENT xau FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(xorg_xau_FRAMEWORKS_FOUND_RELEASE "")
conan_find_apple_frameworks(xorg_xau_FRAMEWORKS_FOUND_RELEASE "${xorg_xau_FRAMEWORKS_RELEASE}" "${xorg_xau_FRAMEWORK_DIRS_RELEASE}")

set(xorg_xau_LIB_TARGETS_RELEASE "")
set(xorg_xau_NOT_USED_RELEASE "")
set(xorg_xau_LIBS_FRAMEWORKS_DEPS_RELEASE ${xorg_xau_FRAMEWORKS_FOUND_RELEASE} ${xorg_xau_SYSTEM_LIBS_RELEASE} ${xorg_xau_DEPENDENCIES_RELEASE})
conan_package_library_targets("${xorg_xau_LIBS_RELEASE}"
                              "${xorg_xau_LIB_DIRS_RELEASE}"
                              "${xorg_xau_LIBS_FRAMEWORKS_DEPS_RELEASE}"
                              xorg_xau_NOT_USED_RELEASE
                              xorg_xau_LIB_TARGETS_RELEASE
                              "RELEASE"
                              "xorg_xau")

set(xorg_xau_LINK_LIBS_RELEASE ${xorg_xau_LIB_TARGETS_RELEASE} ${xorg_xau_LIBS_FRAMEWORKS_DEPS_RELEASE})

########### COMPONENT sm VARIABLES #############################################

set(xorg_sm_INCLUDE_DIRS_RELEASE )
set(xorg_sm_INCLUDE_DIR_RELEASE "")
set(xorg_sm_INCLUDES_RELEASE )
set(xorg_sm_LIB_DIRS_RELEASE )
set(xorg_sm_RES_DIRS_RELEASE )
set(xorg_sm_DEFINITIONS_RELEASE )
set(xorg_sm_COMPILE_DEFINITIONS_RELEASE )
set(xorg_sm_COMPILE_OPTIONS_C_RELEASE "")
set(xorg_sm_COMPILE_OPTIONS_CXX_RELEASE "")
set(xorg_sm_LIBS_RELEASE )
set(xorg_sm_SYSTEM_LIBS_RELEASE SM)
set(xorg_sm_FRAMEWORK_DIRS_RELEASE )
set(xorg_sm_FRAMEWORKS_RELEASE )
set(xorg_sm_BUILD_MODULES_PATHS_RELEASE )
set(xorg_sm_DEPENDENCIES_RELEASE )
set(xorg_sm_LINKER_FLAGS_LIST_RELEASE
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>
)

########## COMPONENT sm FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(xorg_sm_FRAMEWORKS_FOUND_RELEASE "")
conan_find_apple_frameworks(xorg_sm_FRAMEWORKS_FOUND_RELEASE "${xorg_sm_FRAMEWORKS_RELEASE}" "${xorg_sm_FRAMEWORK_DIRS_RELEASE}")

set(xorg_sm_LIB_TARGETS_RELEASE "")
set(xorg_sm_NOT_USED_RELEASE "")
set(xorg_sm_LIBS_FRAMEWORKS_DEPS_RELEASE ${xorg_sm_FRAMEWORKS_FOUND_RELEASE} ${xorg_sm_SYSTEM_LIBS_RELEASE} ${xorg_sm_DEPENDENCIES_RELEASE})
conan_package_library_targets("${xorg_sm_LIBS_RELEASE}"
                              "${xorg_sm_LIB_DIRS_RELEASE}"
                              "${xorg_sm_LIBS_FRAMEWORKS_DEPS_RELEASE}"
                              xorg_sm_NOT_USED_RELEASE
                              xorg_sm_LIB_TARGETS_RELEASE
                              "RELEASE"
                              "xorg_sm")

set(xorg_sm_LINK_LIBS_RELEASE ${xorg_sm_LIB_TARGETS_RELEASE} ${xorg_sm_LIBS_FRAMEWORKS_DEPS_RELEASE})

########### COMPONENT ice VARIABLES #############################################

set(xorg_ice_INCLUDE_DIRS_RELEASE )
set(xorg_ice_INCLUDE_DIR_RELEASE "")
set(xorg_ice_INCLUDES_RELEASE )
set(xorg_ice_LIB_DIRS_RELEASE )
set(xorg_ice_RES_DIRS_RELEASE )
set(xorg_ice_DEFINITIONS_RELEASE )
set(xorg_ice_COMPILE_DEFINITIONS_RELEASE )
set(xorg_ice_COMPILE_OPTIONS_C_RELEASE "")
set(xorg_ice_COMPILE_OPTIONS_CXX_RELEASE "")
set(xorg_ice_LIBS_RELEASE )
set(xorg_ice_SYSTEM_LIBS_RELEASE ICE)
set(xorg_ice_FRAMEWORK_DIRS_RELEASE )
set(xorg_ice_FRAMEWORKS_RELEASE )
set(xorg_ice_BUILD_MODULES_PATHS_RELEASE )
set(xorg_ice_DEPENDENCIES_RELEASE )
set(xorg_ice_LINKER_FLAGS_LIST_RELEASE
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>
)

########## COMPONENT ice FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(xorg_ice_FRAMEWORKS_FOUND_RELEASE "")
conan_find_apple_frameworks(xorg_ice_FRAMEWORKS_FOUND_RELEASE "${xorg_ice_FRAMEWORKS_RELEASE}" "${xorg_ice_FRAMEWORK_DIRS_RELEASE}")

set(xorg_ice_LIB_TARGETS_RELEASE "")
set(xorg_ice_NOT_USED_RELEASE "")
set(xorg_ice_LIBS_FRAMEWORKS_DEPS_RELEASE ${xorg_ice_FRAMEWORKS_FOUND_RELEASE} ${xorg_ice_SYSTEM_LIBS_RELEASE} ${xorg_ice_DEPENDENCIES_RELEASE})
conan_package_library_targets("${xorg_ice_LIBS_RELEASE}"
                              "${xorg_ice_LIB_DIRS_RELEASE}"
                              "${xorg_ice_LIBS_FRAMEWORKS_DEPS_RELEASE}"
                              xorg_ice_NOT_USED_RELEASE
                              xorg_ice_LIB_TARGETS_RELEASE
                              "RELEASE"
                              "xorg_ice")

set(xorg_ice_LINK_LIBS_RELEASE ${xorg_ice_LIB_TARGETS_RELEASE} ${xorg_ice_LIBS_FRAMEWORKS_DEPS_RELEASE})

########### COMPONENT fontenc VARIABLES #############################################

set(xorg_fontenc_INCLUDE_DIRS_RELEASE )
set(xorg_fontenc_INCLUDE_DIR_RELEASE "")
set(xorg_fontenc_INCLUDES_RELEASE )
set(xorg_fontenc_LIB_DIRS_RELEASE )
set(xorg_fontenc_RES_DIRS_RELEASE )
set(xorg_fontenc_DEFINITIONS_RELEASE )
set(xorg_fontenc_COMPILE_DEFINITIONS_RELEASE )
set(xorg_fontenc_COMPILE_OPTIONS_C_RELEASE "")
set(xorg_fontenc_COMPILE_OPTIONS_CXX_RELEASE "")
set(xorg_fontenc_LIBS_RELEASE )
set(xorg_fontenc_SYSTEM_LIBS_RELEASE fontenc)
set(xorg_fontenc_FRAMEWORK_DIRS_RELEASE )
set(xorg_fontenc_FRAMEWORKS_RELEASE )
set(xorg_fontenc_BUILD_MODULES_PATHS_RELEASE )
set(xorg_fontenc_DEPENDENCIES_RELEASE )
set(xorg_fontenc_LINKER_FLAGS_LIST_RELEASE
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>
)

########## COMPONENT fontenc FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(xorg_fontenc_FRAMEWORKS_FOUND_RELEASE "")
conan_find_apple_frameworks(xorg_fontenc_FRAMEWORKS_FOUND_RELEASE "${xorg_fontenc_FRAMEWORKS_RELEASE}" "${xorg_fontenc_FRAMEWORK_DIRS_RELEASE}")

set(xorg_fontenc_LIB_TARGETS_RELEASE "")
set(xorg_fontenc_NOT_USED_RELEASE "")
set(xorg_fontenc_LIBS_FRAMEWORKS_DEPS_RELEASE ${xorg_fontenc_FRAMEWORKS_FOUND_RELEASE} ${xorg_fontenc_SYSTEM_LIBS_RELEASE} ${xorg_fontenc_DEPENDENCIES_RELEASE})
conan_package_library_targets("${xorg_fontenc_LIBS_RELEASE}"
                              "${xorg_fontenc_LIB_DIRS_RELEASE}"
                              "${xorg_fontenc_LIBS_FRAMEWORKS_DEPS_RELEASE}"
                              xorg_fontenc_NOT_USED_RELEASE
                              xorg_fontenc_LIB_TARGETS_RELEASE
                              "RELEASE"
                              "xorg_fontenc")

set(xorg_fontenc_LINK_LIBS_RELEASE ${xorg_fontenc_LIB_TARGETS_RELEASE} ${xorg_fontenc_LIBS_FRAMEWORKS_DEPS_RELEASE})

########### COMPONENT x11-xcb VARIABLES #############################################

set(xorg_x11-xcb_INCLUDE_DIRS_RELEASE )
set(xorg_x11-xcb_INCLUDE_DIR_RELEASE "")
set(xorg_x11-xcb_INCLUDES_RELEASE )
set(xorg_x11-xcb_LIB_DIRS_RELEASE )
set(xorg_x11-xcb_RES_DIRS_RELEASE )
set(xorg_x11-xcb_DEFINITIONS_RELEASE )
set(xorg_x11-xcb_COMPILE_DEFINITIONS_RELEASE )
set(xorg_x11-xcb_COMPILE_OPTIONS_C_RELEASE "")
set(xorg_x11-xcb_COMPILE_OPTIONS_CXX_RELEASE "")
set(xorg_x11-xcb_LIBS_RELEASE )
set(xorg_x11-xcb_SYSTEM_LIBS_RELEASE X11-xcb X11 xcb)
set(xorg_x11-xcb_FRAMEWORK_DIRS_RELEASE )
set(xorg_x11-xcb_FRAMEWORKS_RELEASE )
set(xorg_x11-xcb_BUILD_MODULES_PATHS_RELEASE )
set(xorg_x11-xcb_DEPENDENCIES_RELEASE )
set(xorg_x11-xcb_LINKER_FLAGS_LIST_RELEASE
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>
)

########## COMPONENT x11-xcb FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(xorg_x11-xcb_FRAMEWORKS_FOUND_RELEASE "")
conan_find_apple_frameworks(xorg_x11-xcb_FRAMEWORKS_FOUND_RELEASE "${xorg_x11-xcb_FRAMEWORKS_RELEASE}" "${xorg_x11-xcb_FRAMEWORK_DIRS_RELEASE}")

set(xorg_x11-xcb_LIB_TARGETS_RELEASE "")
set(xorg_x11-xcb_NOT_USED_RELEASE "")
set(xorg_x11-xcb_LIBS_FRAMEWORKS_DEPS_RELEASE ${xorg_x11-xcb_FRAMEWORKS_FOUND_RELEASE} ${xorg_x11-xcb_SYSTEM_LIBS_RELEASE} ${xorg_x11-xcb_DEPENDENCIES_RELEASE})
conan_package_library_targets("${xorg_x11-xcb_LIBS_RELEASE}"
                              "${xorg_x11-xcb_LIB_DIRS_RELEASE}"
                              "${xorg_x11-xcb_LIBS_FRAMEWORKS_DEPS_RELEASE}"
                              xorg_x11-xcb_NOT_USED_RELEASE
                              xorg_x11-xcb_LIB_TARGETS_RELEASE
                              "RELEASE"
                              "xorg_x11-xcb")

set(xorg_x11-xcb_LINK_LIBS_RELEASE ${xorg_x11-xcb_LIB_TARGETS_RELEASE} ${xorg_x11-xcb_LIBS_FRAMEWORKS_DEPS_RELEASE})

########### COMPONENT x11 VARIABLES #############################################

set(xorg_x11_INCLUDE_DIRS_RELEASE )
set(xorg_x11_INCLUDE_DIR_RELEASE "")
set(xorg_x11_INCLUDES_RELEASE )
set(xorg_x11_LIB_DIRS_RELEASE )
set(xorg_x11_RES_DIRS_RELEASE )
set(xorg_x11_DEFINITIONS_RELEASE )
set(xorg_x11_COMPILE_DEFINITIONS_RELEASE )
set(xorg_x11_COMPILE_OPTIONS_C_RELEASE "")
set(xorg_x11_COMPILE_OPTIONS_CXX_RELEASE "")
set(xorg_x11_LIBS_RELEASE )
set(xorg_x11_SYSTEM_LIBS_RELEASE X11)
set(xorg_x11_FRAMEWORK_DIRS_RELEASE )
set(xorg_x11_FRAMEWORKS_RELEASE )
set(xorg_x11_BUILD_MODULES_PATHS_RELEASE )
set(xorg_x11_DEPENDENCIES_RELEASE )
set(xorg_x11_LINKER_FLAGS_LIST_RELEASE
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>
)

########## COMPONENT x11 FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(xorg_x11_FRAMEWORKS_FOUND_RELEASE "")
conan_find_apple_frameworks(xorg_x11_FRAMEWORKS_FOUND_RELEASE "${xorg_x11_FRAMEWORKS_RELEASE}" "${xorg_x11_FRAMEWORK_DIRS_RELEASE}")

set(xorg_x11_LIB_TARGETS_RELEASE "")
set(xorg_x11_NOT_USED_RELEASE "")
set(xorg_x11_LIBS_FRAMEWORKS_DEPS_RELEASE ${xorg_x11_FRAMEWORKS_FOUND_RELEASE} ${xorg_x11_SYSTEM_LIBS_RELEASE} ${xorg_x11_DEPENDENCIES_RELEASE})
conan_package_library_targets("${xorg_x11_LIBS_RELEASE}"
                              "${xorg_x11_LIB_DIRS_RELEASE}"
                              "${xorg_x11_LIBS_FRAMEWORKS_DEPS_RELEASE}"
                              xorg_x11_NOT_USED_RELEASE
                              xorg_x11_LIB_TARGETS_RELEASE
                              "RELEASE"
                              "xorg_x11")

set(xorg_x11_LINK_LIBS_RELEASE ${xorg_x11_LIB_TARGETS_RELEASE} ${xorg_x11_LIBS_FRAMEWORKS_DEPS_RELEASE})