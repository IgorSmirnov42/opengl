
if(NOT TARGET imgui::imgui)
    add_library(imgui::imgui INTERFACE IMPORTED)
endif()

# Load the debug and release library finders
get_filename_component(_DIR "${CMAKE_CURRENT_LIST_FILE}" PATH)
file(GLOB CONFIG_FILES "${_DIR}/imguiTarget-*.cmake")

foreach(f ${CONFIG_FILES})
    include(${f})
endforeach()
