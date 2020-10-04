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


set(GLEW_INCLUDE_DIRS_RELEASE "/home/smirnov-i/.conan/data/glew/2.1.0/_/_/package/161ee116d0f37f134c366b5832500f2812dc7b50/include")
set(GLEW_INCLUDE_DIR_RELEASE "/home/smirnov-i/.conan/data/glew/2.1.0/_/_/package/161ee116d0f37f134c366b5832500f2812dc7b50/include")
set(GLEW_INCLUDES_RELEASE "/home/smirnov-i/.conan/data/glew/2.1.0/_/_/package/161ee116d0f37f134c366b5832500f2812dc7b50/include")
set(GLEW_RES_DIRS_RELEASE )
set(GLEW_DEFINITIONS_RELEASE )
set(GLEW_LINKER_FLAGS_RELEASE_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)
set(GLEW_COMPILE_DEFINITIONS_RELEASE )
set(GLEW_COMPILE_OPTIONS_RELEASE_LIST "" "")
set(GLEW_COMPILE_OPTIONS_C_RELEASE "")
set(GLEW_COMPILE_OPTIONS_CXX_RELEASE "")
set(GLEW_LIBRARIES_TARGETS_RELEASE "") # Will be filled later, if CMake 3
set(GLEW_LIBRARIES_RELEASE "") # Will be filled later
set(GLEW_LIBS_RELEASE "") # Same as GLEW_LIBRARIES
set(GLEW_SYSTEM_LIBS_RELEASE )
set(GLEW_FRAMEWORK_DIRS_RELEASE )
set(GLEW_FRAMEWORKS_RELEASE )
set(GLEW_FRAMEWORKS_FOUND_RELEASE "") # Will be filled later
set(GLEW_BUILD_MODULES_PATHS_RELEASE )

conan_find_apple_frameworks(GLEW_FRAMEWORKS_FOUND_RELEASE "${GLEW_FRAMEWORKS_RELEASE}" "${GLEW_FRAMEWORK_DIRS_RELEASE}")

mark_as_advanced(GLEW_INCLUDE_DIRS_RELEASE
                 GLEW_INCLUDE_DIR_RELEASE
                 GLEW_INCLUDES_RELEASE
                 GLEW_DEFINITIONS_RELEASE
                 GLEW_LINKER_FLAGS_RELEASE_LIST
                 GLEW_COMPILE_DEFINITIONS_RELEASE
                 GLEW_COMPILE_OPTIONS_RELEASE_LIST
                 GLEW_LIBRARIES_RELEASE
                 GLEW_LIBS_RELEASE
                 GLEW_LIBRARIES_TARGETS_RELEASE)

# Find the real .lib/.a and add them to GLEW_LIBS and GLEW_LIBRARY_LIST
set(GLEW_LIBRARY_LIST_RELEASE GLEW)
set(GLEW_LIB_DIRS_RELEASE "/home/smirnov-i/.conan/data/glew/2.1.0/_/_/package/161ee116d0f37f134c366b5832500f2812dc7b50/lib")

# Gather all the libraries that should be linked to the targets (do not touch existing variables):
set(_GLEW_DEPENDENCIES_RELEASE "${GLEW_FRAMEWORKS_FOUND_RELEASE} ${GLEW_SYSTEM_LIBS_RELEASE} opengl::opengl;glu::glu")

conan_package_library_targets("${GLEW_LIBRARY_LIST_RELEASE}"  # libraries
                              "${GLEW_LIB_DIRS_RELEASE}"      # package_libdir
                              "${_GLEW_DEPENDENCIES_RELEASE}"  # deps
                              GLEW_LIBRARIES_RELEASE            # out_libraries
                              GLEW_LIBRARIES_TARGETS_RELEASE    # out_libraries_targets
                              "_RELEASE"                          # build_type
                              "GLEW")                                      # package_name

set(GLEW_LIBS_RELEASE ${GLEW_LIBRARIES_RELEASE})

foreach(_FRAMEWORK ${GLEW_FRAMEWORKS_FOUND_RELEASE})
    list(APPEND GLEW_LIBRARIES_TARGETS_RELEASE ${_FRAMEWORK})
    list(APPEND GLEW_LIBRARIES_RELEASE ${_FRAMEWORK})
endforeach()

foreach(_SYSTEM_LIB ${GLEW_SYSTEM_LIBS_RELEASE})
    list(APPEND GLEW_LIBRARIES_TARGETS_RELEASE ${_SYSTEM_LIB})
    list(APPEND GLEW_LIBRARIES_RELEASE ${_SYSTEM_LIB})
endforeach()

# We need to add our requirements too
set(GLEW_LIBRARIES_TARGETS_RELEASE "${GLEW_LIBRARIES_TARGETS_RELEASE};opengl::opengl;glu::glu")
set(GLEW_LIBRARIES_RELEASE "${GLEW_LIBRARIES_RELEASE};opengl::opengl;glu::glu")

set(CMAKE_MODULE_PATH "/home/smirnov-i/.conan/data/glew/2.1.0/_/_/package/161ee116d0f37f134c366b5832500f2812dc7b50/" ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH "/home/smirnov-i/.conan/data/glew/2.1.0/_/_/package/161ee116d0f37f134c366b5832500f2812dc7b50/" ${CMAKE_PREFIX_PATH})

foreach(_BUILD_MODULE_PATH ${GLEW_BUILD_MODULES_PATHS_RELEASE})
    include(${_BUILD_MODULE_PATH})
endforeach()

set(GLEW_COMPONENTS_RELEASE GLEW::glew_s)

########### COMPONENT glew_s VARIABLES #############################################

set(GLEW_glew_s_INCLUDE_DIRS_RELEASE "/home/smirnov-i/.conan/data/glew/2.1.0/_/_/package/161ee116d0f37f134c366b5832500f2812dc7b50/include")
set(GLEW_glew_s_INCLUDE_DIR_RELEASE "/home/smirnov-i/.conan/data/glew/2.1.0/_/_/package/161ee116d0f37f134c366b5832500f2812dc7b50/include")
set(GLEW_glew_s_INCLUDES_RELEASE "/home/smirnov-i/.conan/data/glew/2.1.0/_/_/package/161ee116d0f37f134c366b5832500f2812dc7b50/include")
set(GLEW_glew_s_LIB_DIRS_RELEASE "/home/smirnov-i/.conan/data/glew/2.1.0/_/_/package/161ee116d0f37f134c366b5832500f2812dc7b50/lib")
set(GLEW_glew_s_RES_DIRS_RELEASE )
set(GLEW_glew_s_DEFINITIONS_RELEASE )
set(GLEW_glew_s_COMPILE_DEFINITIONS_RELEASE )
set(GLEW_glew_s_COMPILE_OPTIONS_C_RELEASE "")
set(GLEW_glew_s_COMPILE_OPTIONS_CXX_RELEASE "")
set(GLEW_glew_s_LIBS_RELEASE GLEW)
set(GLEW_glew_s_SYSTEM_LIBS_RELEASE )
set(GLEW_glew_s_FRAMEWORK_DIRS_RELEASE )
set(GLEW_glew_s_FRAMEWORKS_RELEASE )
set(GLEW_glew_s_BUILD_MODULES_PATHS_RELEASE )
set(GLEW_glew_s_DEPENDENCIES_RELEASE opengl::opengl glu::glu)
set(GLEW_glew_s_LINKER_FLAGS_LIST_RELEASE
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>
)

########## COMPONENT glew_s FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(GLEW_glew_s_FRAMEWORKS_FOUND_RELEASE "")
conan_find_apple_frameworks(GLEW_glew_s_FRAMEWORKS_FOUND_RELEASE "${GLEW_glew_s_FRAMEWORKS_RELEASE}" "${GLEW_glew_s_FRAMEWORK_DIRS_RELEASE}")

set(GLEW_glew_s_LIB_TARGETS_RELEASE "")
set(GLEW_glew_s_NOT_USED_RELEASE "")
set(GLEW_glew_s_LIBS_FRAMEWORKS_DEPS_RELEASE ${GLEW_glew_s_FRAMEWORKS_FOUND_RELEASE} ${GLEW_glew_s_SYSTEM_LIBS_RELEASE} ${GLEW_glew_s_DEPENDENCIES_RELEASE})
conan_package_library_targets("${GLEW_glew_s_LIBS_RELEASE}"
                              "${GLEW_glew_s_LIB_DIRS_RELEASE}"
                              "${GLEW_glew_s_LIBS_FRAMEWORKS_DEPS_RELEASE}"
                              GLEW_glew_s_NOT_USED_RELEASE
                              GLEW_glew_s_LIB_TARGETS_RELEASE
                              "RELEASE"
                              "GLEW_glew_s")

set(GLEW_glew_s_LINK_LIBS_RELEASE ${GLEW_glew_s_LIB_TARGETS_RELEASE} ${GLEW_glew_s_LIBS_FRAMEWORKS_DEPS_RELEASE})