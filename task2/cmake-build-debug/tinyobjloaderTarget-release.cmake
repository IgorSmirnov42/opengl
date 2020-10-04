
set(tinyobjloader_INCLUDE_DIRS_RELEASE "/home/smirnov-i/.conan/data/tinyobjloader/1.0.6/_/_/package/50a5030bbbb13ae56bc4be41915ecd48549cb895/include")
set(tinyobjloader_INCLUDE_DIR_RELEASE "/home/smirnov-i/.conan/data/tinyobjloader/1.0.6/_/_/package/50a5030bbbb13ae56bc4be41915ecd48549cb895/include")
set(tinyobjloader_INCLUDES_RELEASE "/home/smirnov-i/.conan/data/tinyobjloader/1.0.6/_/_/package/50a5030bbbb13ae56bc4be41915ecd48549cb895/include")
set(tinyobjloader_RES_DIRS_RELEASE )
set(tinyobjloader_DEFINITIONS_RELEASE )
set(tinyobjloader_LINKER_FLAGS_RELEASE_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)
set(tinyobjloader_COMPILE_DEFINITIONS_RELEASE )
set(tinyobjloader_COMPILE_OPTIONS_RELEASE_LIST "" "")
set(tinyobjloader_COMPILE_OPTIONS_C_RELEASE "")
set(tinyobjloader_COMPILE_OPTIONS_CXX_RELEASE "")
set(tinyobjloader_LIBRARIES_TARGETS_RELEASE "") # Will be filled later, if CMake 3
set(tinyobjloader_LIBRARIES_RELEASE "") # Will be filled later
set(tinyobjloader_LIBS_RELEASE "") # Same as tinyobjloader_LIBRARIES
set(tinyobjloader_SYSTEM_LIBS_RELEASE )
set(tinyobjloader_FRAMEWORK_DIRS_RELEASE )
set(tinyobjloader_FRAMEWORKS_RELEASE )
set(tinyobjloader_FRAMEWORKS_FOUND_RELEASE "") # Will be filled later
set(tinyobjloader_BUILD_MODULES_PATHS_RELEASE )

conan_find_apple_frameworks(tinyobjloader_FRAMEWORKS_FOUND_RELEASE "${tinyobjloader_FRAMEWORKS_RELEASE}" "${tinyobjloader_FRAMEWORK_DIRS_RELEASE}")

mark_as_advanced(tinyobjloader_INCLUDE_DIRS_RELEASE
                 tinyobjloader_INCLUDE_DIR_RELEASE
                 tinyobjloader_INCLUDES_RELEASE
                 tinyobjloader_DEFINITIONS_RELEASE
                 tinyobjloader_LINKER_FLAGS_RELEASE_LIST
                 tinyobjloader_COMPILE_DEFINITIONS_RELEASE
                 tinyobjloader_COMPILE_OPTIONS_RELEASE_LIST
                 tinyobjloader_LIBRARIES_RELEASE
                 tinyobjloader_LIBS_RELEASE
                 tinyobjloader_LIBRARIES_TARGETS_RELEASE)

# Find the real .lib/.a and add them to tinyobjloader_LIBS and tinyobjloader_LIBRARY_LIST
set(tinyobjloader_LIBRARY_LIST_RELEASE tinyobjloader)
set(tinyobjloader_LIB_DIRS_RELEASE "/home/smirnov-i/.conan/data/tinyobjloader/1.0.6/_/_/package/50a5030bbbb13ae56bc4be41915ecd48549cb895/lib")

# Gather all the libraries that should be linked to the targets (do not touch existing variables):
set(_tinyobjloader_DEPENDENCIES_RELEASE "${tinyobjloader_FRAMEWORKS_FOUND_RELEASE} ${tinyobjloader_SYSTEM_LIBS_RELEASE} ")

conan_package_library_targets("${tinyobjloader_LIBRARY_LIST_RELEASE}"  # libraries
                              "${tinyobjloader_LIB_DIRS_RELEASE}"      # package_libdir
                              "${_tinyobjloader_DEPENDENCIES_RELEASE}"  # deps
                              tinyobjloader_LIBRARIES_RELEASE            # out_libraries
                              tinyobjloader_LIBRARIES_TARGETS_RELEASE    # out_libraries_targets
                              "_RELEASE"                          # build_type
                              "tinyobjloader")                                      # package_name

set(tinyobjloader_LIBS_RELEASE ${tinyobjloader_LIBRARIES_RELEASE})

foreach(_FRAMEWORK ${tinyobjloader_FRAMEWORKS_FOUND_RELEASE})
    list(APPEND tinyobjloader_LIBRARIES_TARGETS_RELEASE ${_FRAMEWORK})
    list(APPEND tinyobjloader_LIBRARIES_RELEASE ${_FRAMEWORK})
endforeach()

foreach(_SYSTEM_LIB ${tinyobjloader_SYSTEM_LIBS_RELEASE})
    list(APPEND tinyobjloader_LIBRARIES_TARGETS_RELEASE ${_SYSTEM_LIB})
    list(APPEND tinyobjloader_LIBRARIES_RELEASE ${_SYSTEM_LIB})
endforeach()

# We need to add our requirements too
set(tinyobjloader_LIBRARIES_TARGETS_RELEASE "${tinyobjloader_LIBRARIES_TARGETS_RELEASE};")
set(tinyobjloader_LIBRARIES_RELEASE "${tinyobjloader_LIBRARIES_RELEASE};")

set(CMAKE_MODULE_PATH "/home/smirnov-i/.conan/data/tinyobjloader/1.0.6/_/_/package/50a5030bbbb13ae56bc4be41915ecd48549cb895/" ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH "/home/smirnov-i/.conan/data/tinyobjloader/1.0.6/_/_/package/50a5030bbbb13ae56bc4be41915ecd48549cb895/" ${CMAKE_PREFIX_PATH})

foreach(_BUILD_MODULE_PATH ${tinyobjloader_BUILD_MODULES_PATHS_RELEASE})
    include(${_BUILD_MODULE_PATH})
endforeach()
