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


set(fmt_INCLUDE_DIRS_RELEASE "/home/smirnov-i/.conan/data/fmt/7.0.3/_/_/package/5ab84d6acfe1f23c4fae0ab88f26e3a396351ac9/include")
set(fmt_INCLUDE_DIR_RELEASE "/home/smirnov-i/.conan/data/fmt/7.0.3/_/_/package/5ab84d6acfe1f23c4fae0ab88f26e3a396351ac9/include")
set(fmt_INCLUDES_RELEASE "/home/smirnov-i/.conan/data/fmt/7.0.3/_/_/package/5ab84d6acfe1f23c4fae0ab88f26e3a396351ac9/include")
set(fmt_RES_DIRS_RELEASE )
set(fmt_DEFINITIONS_RELEASE "-DFMT_HEADER_ONLY=1")
set(fmt_LINKER_FLAGS_RELEASE_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)
set(fmt_COMPILE_DEFINITIONS_RELEASE "FMT_HEADER_ONLY=1")
set(fmt_COMPILE_OPTIONS_RELEASE_LIST "" "")
set(fmt_COMPILE_OPTIONS_C_RELEASE "")
set(fmt_COMPILE_OPTIONS_CXX_RELEASE "")
set(fmt_LIBRARIES_TARGETS_RELEASE "") # Will be filled later, if CMake 3
set(fmt_LIBRARIES_RELEASE "") # Will be filled later
set(fmt_LIBS_RELEASE "") # Same as fmt_LIBRARIES
set(fmt_SYSTEM_LIBS_RELEASE )
set(fmt_FRAMEWORK_DIRS_RELEASE )
set(fmt_FRAMEWORKS_RELEASE )
set(fmt_FRAMEWORKS_FOUND_RELEASE "") # Will be filled later
set(fmt_BUILD_MODULES_PATHS_RELEASE )

conan_find_apple_frameworks(fmt_FRAMEWORKS_FOUND_RELEASE "${fmt_FRAMEWORKS_RELEASE}" "${fmt_FRAMEWORK_DIRS_RELEASE}")

mark_as_advanced(fmt_INCLUDE_DIRS_RELEASE
                 fmt_INCLUDE_DIR_RELEASE
                 fmt_INCLUDES_RELEASE
                 fmt_DEFINITIONS_RELEASE
                 fmt_LINKER_FLAGS_RELEASE_LIST
                 fmt_COMPILE_DEFINITIONS_RELEASE
                 fmt_COMPILE_OPTIONS_RELEASE_LIST
                 fmt_LIBRARIES_RELEASE
                 fmt_LIBS_RELEASE
                 fmt_LIBRARIES_TARGETS_RELEASE)

# Find the real .lib/.a and add them to fmt_LIBS and fmt_LIBRARY_LIST
set(fmt_LIBRARY_LIST_RELEASE )
set(fmt_LIB_DIRS_RELEASE )

# Gather all the libraries that should be linked to the targets (do not touch existing variables):
set(_fmt_DEPENDENCIES_RELEASE "${fmt_FRAMEWORKS_FOUND_RELEASE} ${fmt_SYSTEM_LIBS_RELEASE} ")

conan_package_library_targets("${fmt_LIBRARY_LIST_RELEASE}"  # libraries
                              "${fmt_LIB_DIRS_RELEASE}"      # package_libdir
                              "${_fmt_DEPENDENCIES_RELEASE}"  # deps
                              fmt_LIBRARIES_RELEASE            # out_libraries
                              fmt_LIBRARIES_TARGETS_RELEASE    # out_libraries_targets
                              "_RELEASE"                          # build_type
                              "fmt")                                      # package_name

set(fmt_LIBS_RELEASE ${fmt_LIBRARIES_RELEASE})

foreach(_FRAMEWORK ${fmt_FRAMEWORKS_FOUND_RELEASE})
    list(APPEND fmt_LIBRARIES_TARGETS_RELEASE ${_FRAMEWORK})
    list(APPEND fmt_LIBRARIES_RELEASE ${_FRAMEWORK})
endforeach()

foreach(_SYSTEM_LIB ${fmt_SYSTEM_LIBS_RELEASE})
    list(APPEND fmt_LIBRARIES_TARGETS_RELEASE ${_SYSTEM_LIB})
    list(APPEND fmt_LIBRARIES_RELEASE ${_SYSTEM_LIB})
endforeach()

# We need to add our requirements too
set(fmt_LIBRARIES_TARGETS_RELEASE "${fmt_LIBRARIES_TARGETS_RELEASE};")
set(fmt_LIBRARIES_RELEASE "${fmt_LIBRARIES_RELEASE};")

set(CMAKE_MODULE_PATH "/home/smirnov-i/.conan/data/fmt/7.0.3/_/_/package/5ab84d6acfe1f23c4fae0ab88f26e3a396351ac9/" ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH "/home/smirnov-i/.conan/data/fmt/7.0.3/_/_/package/5ab84d6acfe1f23c4fae0ab88f26e3a396351ac9/" ${CMAKE_PREFIX_PATH})

foreach(_BUILD_MODULE_PATH ${fmt_BUILD_MODULES_PATHS_RELEASE})
    include(${_BUILD_MODULE_PATH})
endforeach()

set(fmt_COMPONENTS_RELEASE fmt::fmt-header-only)

########### COMPONENT fmt-header-only VARIABLES #############################################

set(fmt_fmt-header-only_INCLUDE_DIRS_RELEASE "/home/smirnov-i/.conan/data/fmt/7.0.3/_/_/package/5ab84d6acfe1f23c4fae0ab88f26e3a396351ac9/include")
set(fmt_fmt-header-only_INCLUDE_DIR_RELEASE "/home/smirnov-i/.conan/data/fmt/7.0.3/_/_/package/5ab84d6acfe1f23c4fae0ab88f26e3a396351ac9/include")
set(fmt_fmt-header-only_INCLUDES_RELEASE "/home/smirnov-i/.conan/data/fmt/7.0.3/_/_/package/5ab84d6acfe1f23c4fae0ab88f26e3a396351ac9/include")
set(fmt_fmt-header-only_LIB_DIRS_RELEASE )
set(fmt_fmt-header-only_RES_DIRS_RELEASE )
set(fmt_fmt-header-only_DEFINITIONS_RELEASE "-DFMT_HEADER_ONLY=1")
set(fmt_fmt-header-only_COMPILE_DEFINITIONS_RELEASE "FMT_HEADER_ONLY=1")
set(fmt_fmt-header-only_COMPILE_OPTIONS_C_RELEASE "")
set(fmt_fmt-header-only_COMPILE_OPTIONS_CXX_RELEASE "")
set(fmt_fmt-header-only_LIBS_RELEASE )
set(fmt_fmt-header-only_SYSTEM_LIBS_RELEASE )
set(fmt_fmt-header-only_FRAMEWORK_DIRS_RELEASE )
set(fmt_fmt-header-only_FRAMEWORKS_RELEASE )
set(fmt_fmt-header-only_BUILD_MODULES_PATHS_RELEASE )
set(fmt_fmt-header-only_DEPENDENCIES_RELEASE )
set(fmt_fmt-header-only_LINKER_FLAGS_LIST_RELEASE
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>
)

########## COMPONENT fmt-header-only FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(fmt_fmt-header-only_FRAMEWORKS_FOUND_RELEASE "")
conan_find_apple_frameworks(fmt_fmt-header-only_FRAMEWORKS_FOUND_RELEASE "${fmt_fmt-header-only_FRAMEWORKS_RELEASE}" "${fmt_fmt-header-only_FRAMEWORK_DIRS_RELEASE}")

set(fmt_fmt-header-only_LIB_TARGETS_RELEASE "")
set(fmt_fmt-header-only_NOT_USED_RELEASE "")
set(fmt_fmt-header-only_LIBS_FRAMEWORKS_DEPS_RELEASE ${fmt_fmt-header-only_FRAMEWORKS_FOUND_RELEASE} ${fmt_fmt-header-only_SYSTEM_LIBS_RELEASE} ${fmt_fmt-header-only_DEPENDENCIES_RELEASE})
conan_package_library_targets("${fmt_fmt-header-only_LIBS_RELEASE}"
                              "${fmt_fmt-header-only_LIB_DIRS_RELEASE}"
                              "${fmt_fmt-header-only_LIBS_FRAMEWORKS_DEPS_RELEASE}"
                              fmt_fmt-header-only_NOT_USED_RELEASE
                              fmt_fmt-header-only_LIB_TARGETS_RELEASE
                              "RELEASE"
                              "fmt_fmt-header-only")

set(fmt_fmt-header-only_LINK_LIBS_RELEASE ${fmt_fmt-header-only_LIB_TARGETS_RELEASE} ${fmt_fmt-header-only_LIBS_FRAMEWORKS_DEPS_RELEASE})