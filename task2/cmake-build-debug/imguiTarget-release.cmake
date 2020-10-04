
set(imgui_INCLUDE_DIRS_RELEASE "/home/smirnov-i/.conan/data/imgui/1.74/_/_/package/50a5030bbbb13ae56bc4be41915ecd48549cb895/include")
set(imgui_INCLUDE_DIR_RELEASE "/home/smirnov-i/.conan/data/imgui/1.74/_/_/package/50a5030bbbb13ae56bc4be41915ecd48549cb895/include")
set(imgui_INCLUDES_RELEASE "/home/smirnov-i/.conan/data/imgui/1.74/_/_/package/50a5030bbbb13ae56bc4be41915ecd48549cb895/include")
set(imgui_RES_DIRS_RELEASE "/home/smirnov-i/.conan/data/imgui/1.74/_/_/package/50a5030bbbb13ae56bc4be41915ecd48549cb895/res")
set(imgui_DEFINITIONS_RELEASE )
set(imgui_LINKER_FLAGS_RELEASE_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)
set(imgui_COMPILE_DEFINITIONS_RELEASE )
set(imgui_COMPILE_OPTIONS_RELEASE_LIST "" "")
set(imgui_COMPILE_OPTIONS_C_RELEASE "")
set(imgui_COMPILE_OPTIONS_CXX_RELEASE "")
set(imgui_LIBRARIES_TARGETS_RELEASE "") # Will be filled later, if CMake 3
set(imgui_LIBRARIES_RELEASE "") # Will be filled later
set(imgui_LIBS_RELEASE "") # Same as imgui_LIBRARIES
set(imgui_SYSTEM_LIBS_RELEASE m)
set(imgui_FRAMEWORK_DIRS_RELEASE )
set(imgui_FRAMEWORKS_RELEASE )
set(imgui_FRAMEWORKS_FOUND_RELEASE "") # Will be filled later
set(imgui_BUILD_MODULES_PATHS_RELEASE )

conan_find_apple_frameworks(imgui_FRAMEWORKS_FOUND_RELEASE "${imgui_FRAMEWORKS_RELEASE}" "${imgui_FRAMEWORK_DIRS_RELEASE}")

mark_as_advanced(imgui_INCLUDE_DIRS_RELEASE
                 imgui_INCLUDE_DIR_RELEASE
                 imgui_INCLUDES_RELEASE
                 imgui_DEFINITIONS_RELEASE
                 imgui_LINKER_FLAGS_RELEASE_LIST
                 imgui_COMPILE_DEFINITIONS_RELEASE
                 imgui_COMPILE_OPTIONS_RELEASE_LIST
                 imgui_LIBRARIES_RELEASE
                 imgui_LIBS_RELEASE
                 imgui_LIBRARIES_TARGETS_RELEASE)

# Find the real .lib/.a and add them to imgui_LIBS and imgui_LIBRARY_LIST
set(imgui_LIBRARY_LIST_RELEASE imgui)
set(imgui_LIB_DIRS_RELEASE "/home/smirnov-i/.conan/data/imgui/1.74/_/_/package/50a5030bbbb13ae56bc4be41915ecd48549cb895/lib")

# Gather all the libraries that should be linked to the targets (do not touch existing variables):
set(_imgui_DEPENDENCIES_RELEASE "${imgui_FRAMEWORKS_FOUND_RELEASE} ${imgui_SYSTEM_LIBS_RELEASE} ")

conan_package_library_targets("${imgui_LIBRARY_LIST_RELEASE}"  # libraries
                              "${imgui_LIB_DIRS_RELEASE}"      # package_libdir
                              "${_imgui_DEPENDENCIES_RELEASE}"  # deps
                              imgui_LIBRARIES_RELEASE            # out_libraries
                              imgui_LIBRARIES_TARGETS_RELEASE    # out_libraries_targets
                              "_RELEASE"                          # build_type
                              "imgui")                                      # package_name

set(imgui_LIBS_RELEASE ${imgui_LIBRARIES_RELEASE})

foreach(_FRAMEWORK ${imgui_FRAMEWORKS_FOUND_RELEASE})
    list(APPEND imgui_LIBRARIES_TARGETS_RELEASE ${_FRAMEWORK})
    list(APPEND imgui_LIBRARIES_RELEASE ${_FRAMEWORK})
endforeach()

foreach(_SYSTEM_LIB ${imgui_SYSTEM_LIBS_RELEASE})
    list(APPEND imgui_LIBRARIES_TARGETS_RELEASE ${_SYSTEM_LIB})
    list(APPEND imgui_LIBRARIES_RELEASE ${_SYSTEM_LIB})
endforeach()

# We need to add our requirements too
set(imgui_LIBRARIES_TARGETS_RELEASE "${imgui_LIBRARIES_TARGETS_RELEASE};")
set(imgui_LIBRARIES_RELEASE "${imgui_LIBRARIES_RELEASE};")

set(CMAKE_MODULE_PATH "/home/smirnov-i/.conan/data/imgui/1.74/_/_/package/50a5030bbbb13ae56bc4be41915ecd48549cb895/" ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH "/home/smirnov-i/.conan/data/imgui/1.74/_/_/package/50a5030bbbb13ae56bc4be41915ecd48549cb895/" ${CMAKE_PREFIX_PATH})

foreach(_BUILD_MODULE_PATH ${imgui_BUILD_MODULES_PATHS_RELEASE})
    include(${_BUILD_MODULE_PATH})
endforeach()
