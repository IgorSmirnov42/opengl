
set(opengl_INCLUDE_DIRS_RELEASE )
set(opengl_INCLUDE_DIR_RELEASE "")
set(opengl_INCLUDES_RELEASE )
set(opengl_RES_DIRS_RELEASE )
set(opengl_DEFINITIONS_RELEASE )
set(opengl_LINKER_FLAGS_RELEASE_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)
set(opengl_COMPILE_DEFINITIONS_RELEASE )
set(opengl_COMPILE_OPTIONS_RELEASE_LIST "" "")
set(opengl_COMPILE_OPTIONS_C_RELEASE "")
set(opengl_COMPILE_OPTIONS_CXX_RELEASE "")
set(opengl_LIBRARIES_TARGETS_RELEASE "") # Will be filled later, if CMake 3
set(opengl_LIBRARIES_RELEASE "") # Will be filled later
set(opengl_LIBS_RELEASE "") # Same as opengl_LIBRARIES
set(opengl_SYSTEM_LIBS_RELEASE GL)
set(opengl_FRAMEWORK_DIRS_RELEASE )
set(opengl_FRAMEWORKS_RELEASE )
set(opengl_FRAMEWORKS_FOUND_RELEASE "") # Will be filled later
set(opengl_BUILD_MODULES_PATHS_RELEASE )

conan_find_apple_frameworks(opengl_FRAMEWORKS_FOUND_RELEASE "${opengl_FRAMEWORKS_RELEASE}" "${opengl_FRAMEWORK_DIRS_RELEASE}")

mark_as_advanced(opengl_INCLUDE_DIRS_RELEASE
                 opengl_INCLUDE_DIR_RELEASE
                 opengl_INCLUDES_RELEASE
                 opengl_DEFINITIONS_RELEASE
                 opengl_LINKER_FLAGS_RELEASE_LIST
                 opengl_COMPILE_DEFINITIONS_RELEASE
                 opengl_COMPILE_OPTIONS_RELEASE_LIST
                 opengl_LIBRARIES_RELEASE
                 opengl_LIBS_RELEASE
                 opengl_LIBRARIES_TARGETS_RELEASE)

# Find the real .lib/.a and add them to opengl_LIBS and opengl_LIBRARY_LIST
set(opengl_LIBRARY_LIST_RELEASE )
set(opengl_LIB_DIRS_RELEASE )

# Gather all the libraries that should be linked to the targets (do not touch existing variables):
set(_opengl_DEPENDENCIES_RELEASE "${opengl_FRAMEWORKS_FOUND_RELEASE} ${opengl_SYSTEM_LIBS_RELEASE} ")

conan_package_library_targets("${opengl_LIBRARY_LIST_RELEASE}"  # libraries
                              "${opengl_LIB_DIRS_RELEASE}"      # package_libdir
                              "${_opengl_DEPENDENCIES_RELEASE}"  # deps
                              opengl_LIBRARIES_RELEASE            # out_libraries
                              opengl_LIBRARIES_TARGETS_RELEASE    # out_libraries_targets
                              "_RELEASE"                          # build_type
                              "opengl")                                      # package_name

set(opengl_LIBS_RELEASE ${opengl_LIBRARIES_RELEASE})

foreach(_FRAMEWORK ${opengl_FRAMEWORKS_FOUND_RELEASE})
    list(APPEND opengl_LIBRARIES_TARGETS_RELEASE ${_FRAMEWORK})
    list(APPEND opengl_LIBRARIES_RELEASE ${_FRAMEWORK})
endforeach()

foreach(_SYSTEM_LIB ${opengl_SYSTEM_LIBS_RELEASE})
    list(APPEND opengl_LIBRARIES_TARGETS_RELEASE ${_SYSTEM_LIB})
    list(APPEND opengl_LIBRARIES_RELEASE ${_SYSTEM_LIB})
endforeach()

# We need to add our requirements too
set(opengl_LIBRARIES_TARGETS_RELEASE "${opengl_LIBRARIES_TARGETS_RELEASE};")
set(opengl_LIBRARIES_RELEASE "${opengl_LIBRARIES_RELEASE};")

set(CMAKE_MODULE_PATH "/home/smirnov-i/.conan/data/opengl/system/_/_/package/5ab84d6acfe1f23c4fae0ab88f26e3a396351ac9/" ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH "/home/smirnov-i/.conan/data/opengl/system/_/_/package/5ab84d6acfe1f23c4fae0ab88f26e3a396351ac9/" ${CMAKE_PREFIX_PATH})

foreach(_BUILD_MODULE_PATH ${opengl_BUILD_MODULES_PATHS_RELEASE})
    include(${_BUILD_MODULE_PATH})
endforeach()
