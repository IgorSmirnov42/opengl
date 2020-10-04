
set(glm_INCLUDE_DIRS_RELEASE "/home/smirnov-i/.conan/data/glm/0.9.9.8/_/_/package/5ab84d6acfe1f23c4fae0ab88f26e3a396351ac9/include")
set(glm_INCLUDE_DIR_RELEASE "/home/smirnov-i/.conan/data/glm/0.9.9.8/_/_/package/5ab84d6acfe1f23c4fae0ab88f26e3a396351ac9/include")
set(glm_INCLUDES_RELEASE "/home/smirnov-i/.conan/data/glm/0.9.9.8/_/_/package/5ab84d6acfe1f23c4fae0ab88f26e3a396351ac9/include")
set(glm_RES_DIRS_RELEASE )
set(glm_DEFINITIONS_RELEASE )
set(glm_LINKER_FLAGS_RELEASE_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)
set(glm_COMPILE_DEFINITIONS_RELEASE )
set(glm_COMPILE_OPTIONS_RELEASE_LIST "" "")
set(glm_COMPILE_OPTIONS_C_RELEASE "")
set(glm_COMPILE_OPTIONS_CXX_RELEASE "")
set(glm_LIBRARIES_TARGETS_RELEASE "") # Will be filled later, if CMake 3
set(glm_LIBRARIES_RELEASE "") # Will be filled later
set(glm_LIBS_RELEASE "") # Same as glm_LIBRARIES
set(glm_SYSTEM_LIBS_RELEASE )
set(glm_FRAMEWORK_DIRS_RELEASE )
set(glm_FRAMEWORKS_RELEASE )
set(glm_FRAMEWORKS_FOUND_RELEASE "") # Will be filled later
set(glm_BUILD_MODULES_PATHS_RELEASE )

conan_find_apple_frameworks(glm_FRAMEWORKS_FOUND_RELEASE "${glm_FRAMEWORKS_RELEASE}" "${glm_FRAMEWORK_DIRS_RELEASE}")

mark_as_advanced(glm_INCLUDE_DIRS_RELEASE
                 glm_INCLUDE_DIR_RELEASE
                 glm_INCLUDES_RELEASE
                 glm_DEFINITIONS_RELEASE
                 glm_LINKER_FLAGS_RELEASE_LIST
                 glm_COMPILE_DEFINITIONS_RELEASE
                 glm_COMPILE_OPTIONS_RELEASE_LIST
                 glm_LIBRARIES_RELEASE
                 glm_LIBS_RELEASE
                 glm_LIBRARIES_TARGETS_RELEASE)

# Find the real .lib/.a and add them to glm_LIBS and glm_LIBRARY_LIST
set(glm_LIBRARY_LIST_RELEASE )
set(glm_LIB_DIRS_RELEASE )

# Gather all the libraries that should be linked to the targets (do not touch existing variables):
set(_glm_DEPENDENCIES_RELEASE "${glm_FRAMEWORKS_FOUND_RELEASE} ${glm_SYSTEM_LIBS_RELEASE} ")

conan_package_library_targets("${glm_LIBRARY_LIST_RELEASE}"  # libraries
                              "${glm_LIB_DIRS_RELEASE}"      # package_libdir
                              "${_glm_DEPENDENCIES_RELEASE}"  # deps
                              glm_LIBRARIES_RELEASE            # out_libraries
                              glm_LIBRARIES_TARGETS_RELEASE    # out_libraries_targets
                              "_RELEASE"                          # build_type
                              "glm")                                      # package_name

set(glm_LIBS_RELEASE ${glm_LIBRARIES_RELEASE})

foreach(_FRAMEWORK ${glm_FRAMEWORKS_FOUND_RELEASE})
    list(APPEND glm_LIBRARIES_TARGETS_RELEASE ${_FRAMEWORK})
    list(APPEND glm_LIBRARIES_RELEASE ${_FRAMEWORK})
endforeach()

foreach(_SYSTEM_LIB ${glm_SYSTEM_LIBS_RELEASE})
    list(APPEND glm_LIBRARIES_TARGETS_RELEASE ${_SYSTEM_LIB})
    list(APPEND glm_LIBRARIES_RELEASE ${_SYSTEM_LIB})
endforeach()

# We need to add our requirements too
set(glm_LIBRARIES_TARGETS_RELEASE "${glm_LIBRARIES_TARGETS_RELEASE};")
set(glm_LIBRARIES_RELEASE "${glm_LIBRARIES_RELEASE};")

set(CMAKE_MODULE_PATH "/home/smirnov-i/.conan/data/glm/0.9.9.8/_/_/package/5ab84d6acfe1f23c4fae0ab88f26e3a396351ac9/" ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH "/home/smirnov-i/.conan/data/glm/0.9.9.8/_/_/package/5ab84d6acfe1f23c4fae0ab88f26e3a396351ac9/" ${CMAKE_PREFIX_PATH})

foreach(_BUILD_MODULE_PATH ${glm_BUILD_MODULES_PATHS_RELEASE})
    include(${_BUILD_MODULE_PATH})
endforeach()
