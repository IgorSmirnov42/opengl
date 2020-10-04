
set(glu_INCLUDE_DIRS_RELEASE )
set(glu_INCLUDE_DIR_RELEASE "")
set(glu_INCLUDES_RELEASE )
set(glu_RES_DIRS_RELEASE )
set(glu_DEFINITIONS_RELEASE )
set(glu_LINKER_FLAGS_RELEASE_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)
set(glu_COMPILE_DEFINITIONS_RELEASE )
set(glu_COMPILE_OPTIONS_RELEASE_LIST "" "")
set(glu_COMPILE_OPTIONS_C_RELEASE "")
set(glu_COMPILE_OPTIONS_CXX_RELEASE "")
set(glu_LIBRARIES_TARGETS_RELEASE "") # Will be filled later, if CMake 3
set(glu_LIBRARIES_RELEASE "") # Will be filled later
set(glu_LIBS_RELEASE "") # Same as glu_LIBRARIES
set(glu_SYSTEM_LIBS_RELEASE GLU GL)
set(glu_FRAMEWORK_DIRS_RELEASE )
set(glu_FRAMEWORKS_RELEASE )
set(glu_FRAMEWORKS_FOUND_RELEASE "") # Will be filled later
set(glu_BUILD_MODULES_PATHS_RELEASE )

conan_find_apple_frameworks(glu_FRAMEWORKS_FOUND_RELEASE "${glu_FRAMEWORKS_RELEASE}" "${glu_FRAMEWORK_DIRS_RELEASE}")

mark_as_advanced(glu_INCLUDE_DIRS_RELEASE
                 glu_INCLUDE_DIR_RELEASE
                 glu_INCLUDES_RELEASE
                 glu_DEFINITIONS_RELEASE
                 glu_LINKER_FLAGS_RELEASE_LIST
                 glu_COMPILE_DEFINITIONS_RELEASE
                 glu_COMPILE_OPTIONS_RELEASE_LIST
                 glu_LIBRARIES_RELEASE
                 glu_LIBS_RELEASE
                 glu_LIBRARIES_TARGETS_RELEASE)

# Find the real .lib/.a and add them to glu_LIBS and glu_LIBRARY_LIST
set(glu_LIBRARY_LIST_RELEASE )
set(glu_LIB_DIRS_RELEASE )

# Gather all the libraries that should be linked to the targets (do not touch existing variables):
set(_glu_DEPENDENCIES_RELEASE "${glu_FRAMEWORKS_FOUND_RELEASE} ${glu_SYSTEM_LIBS_RELEASE} opengl::opengl")

conan_package_library_targets("${glu_LIBRARY_LIST_RELEASE}"  # libraries
                              "${glu_LIB_DIRS_RELEASE}"      # package_libdir
                              "${_glu_DEPENDENCIES_RELEASE}"  # deps
                              glu_LIBRARIES_RELEASE            # out_libraries
                              glu_LIBRARIES_TARGETS_RELEASE    # out_libraries_targets
                              "_RELEASE"                          # build_type
                              "glu")                                      # package_name

set(glu_LIBS_RELEASE ${glu_LIBRARIES_RELEASE})

foreach(_FRAMEWORK ${glu_FRAMEWORKS_FOUND_RELEASE})
    list(APPEND glu_LIBRARIES_TARGETS_RELEASE ${_FRAMEWORK})
    list(APPEND glu_LIBRARIES_RELEASE ${_FRAMEWORK})
endforeach()

foreach(_SYSTEM_LIB ${glu_SYSTEM_LIBS_RELEASE})
    list(APPEND glu_LIBRARIES_TARGETS_RELEASE ${_SYSTEM_LIB})
    list(APPEND glu_LIBRARIES_RELEASE ${_SYSTEM_LIB})
endforeach()

# We need to add our requirements too
set(glu_LIBRARIES_TARGETS_RELEASE "${glu_LIBRARIES_TARGETS_RELEASE};opengl::opengl")
set(glu_LIBRARIES_RELEASE "${glu_LIBRARIES_RELEASE};opengl::opengl")

set(CMAKE_MODULE_PATH "/home/smirnov-i/.conan/data/glu/system/_/_/package/5ab84d6acfe1f23c4fae0ab88f26e3a396351ac9/" ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH "/home/smirnov-i/.conan/data/glu/system/_/_/package/5ab84d6acfe1f23c4fae0ab88f26e3a396351ac9/" ${CMAKE_PREFIX_PATH})

foreach(_BUILD_MODULE_PATH ${glu_BUILD_MODULES_PATHS_RELEASE})
    include(${_BUILD_MODULE_PATH})
endforeach()
