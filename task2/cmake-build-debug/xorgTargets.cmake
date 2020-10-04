

if(NOT TARGET xorg::xkeyboard-config)
    add_library(xorg::xkeyboard-config INTERFACE IMPORTED)
endif()

if(NOT TARGET xorg::xcb)
    add_library(xorg::xcb INTERFACE IMPORTED)
endif()

if(NOT TARGET xorg::xcb-xinerama)
    add_library(xorg::xcb-xinerama INTERFACE IMPORTED)
endif()

if(NOT TARGET xorg::xcb-xfixes)
    add_library(xorg::xcb-xfixes INTERFACE IMPORTED)
endif()

if(NOT TARGET xorg::xcb-sync)
    add_library(xorg::xcb-sync INTERFACE IMPORTED)
endif()

if(NOT TARGET xorg::xcb-shm)
    add_library(xorg::xcb-shm INTERFACE IMPORTED)
endif()

if(NOT TARGET xorg::xcb-shape)
    add_library(xorg::xcb-shape INTERFACE IMPORTED)
endif()

if(NOT TARGET xorg::xcb-renderutil)
    add_library(xorg::xcb-renderutil INTERFACE IMPORTED)
endif()

if(NOT TARGET xorg::xcb-render)
    add_library(xorg::xcb-render INTERFACE IMPORTED)
endif()

if(NOT TARGET xorg::xcb-randr)
    add_library(xorg::xcb-randr INTERFACE IMPORTED)
endif()

if(NOT TARGET xorg::xcb-keysyms)
    add_library(xorg::xcb-keysyms INTERFACE IMPORTED)
endif()

if(NOT TARGET xorg::xcb-image)
    add_library(xorg::xcb-image INTERFACE IMPORTED)
endif()

if(NOT TARGET xorg::xcb-icccm)
    add_library(xorg::xcb-icccm INTERFACE IMPORTED)
endif()

if(NOT TARGET xorg::xcb-xkb)
    add_library(xorg::xcb-xkb INTERFACE IMPORTED)
endif()

if(NOT TARGET xorg::xtrans)
    add_library(xorg::xtrans INTERFACE IMPORTED)
endif()

if(NOT TARGET xorg::xxf86vm)
    add_library(xorg::xxf86vm INTERFACE IMPORTED)
endif()

if(NOT TARGET xorg::xvmc)
    add_library(xorg::xvmc INTERFACE IMPORTED)
endif()

if(NOT TARGET xorg::xv)
    add_library(xorg::xv INTERFACE IMPORTED)
endif()

if(NOT TARGET xorg::xtst)
    add_library(xorg::xtst INTERFACE IMPORTED)
endif()

if(NOT TARGET xorg::xt)
    add_library(xorg::xt INTERFACE IMPORTED)
endif()

if(NOT TARGET xorg::xscrnsaver)
    add_library(xorg::xscrnsaver INTERFACE IMPORTED)
endif()

if(NOT TARGET xorg::xres)
    add_library(xorg::xres INTERFACE IMPORTED)
endif()

if(NOT TARGET xorg::xrender)
    add_library(xorg::xrender INTERFACE IMPORTED)
endif()

if(NOT TARGET xorg::xrandr)
    add_library(xorg::xrandr INTERFACE IMPORTED)
endif()

if(NOT TARGET xorg::xpm)
    add_library(xorg::xpm INTERFACE IMPORTED)
endif()

if(NOT TARGET xorg::xmuu)
    add_library(xorg::xmuu INTERFACE IMPORTED)
endif()

if(NOT TARGET xorg::xmu)
    add_library(xorg::xmu INTERFACE IMPORTED)
endif()

if(NOT TARGET xorg::xkbfile)
    add_library(xorg::xkbfile INTERFACE IMPORTED)
endif()

if(NOT TARGET xorg::xinerama)
    add_library(xorg::xinerama INTERFACE IMPORTED)
endif()

if(NOT TARGET xorg::xi)
    add_library(xorg::xi INTERFACE IMPORTED)
endif()

if(NOT TARGET xorg::xft)
    add_library(xorg::xft INTERFACE IMPORTED)
endif()

if(NOT TARGET xorg::xfixes)
    add_library(xorg::xfixes INTERFACE IMPORTED)
endif()

if(NOT TARGET xorg::xext)
    add_library(xorg::xext INTERFACE IMPORTED)
endif()

if(NOT TARGET xorg::xdmcp)
    add_library(xorg::xdmcp INTERFACE IMPORTED)
endif()

if(NOT TARGET xorg::xdamage)
    add_library(xorg::xdamage INTERFACE IMPORTED)
endif()

if(NOT TARGET xorg::xcursor)
    add_library(xorg::xcursor INTERFACE IMPORTED)
endif()

if(NOT TARGET xorg::xcomposite)
    add_library(xorg::xcomposite INTERFACE IMPORTED)
endif()

if(NOT TARGET xorg::xaw7)
    add_library(xorg::xaw7 INTERFACE IMPORTED)
endif()

if(NOT TARGET xorg::xau)
    add_library(xorg::xau INTERFACE IMPORTED)
endif()

if(NOT TARGET xorg::sm)
    add_library(xorg::sm INTERFACE IMPORTED)
endif()

if(NOT TARGET xorg::ice)
    add_library(xorg::ice INTERFACE IMPORTED)
endif()

if(NOT TARGET xorg::fontenc)
    add_library(xorg::fontenc INTERFACE IMPORTED)
endif()

if(NOT TARGET xorg::x11-xcb)
    add_library(xorg::x11-xcb INTERFACE IMPORTED)
endif()

if(NOT TARGET xorg::x11)
    add_library(xorg::x11 INTERFACE IMPORTED)
endif()

if(NOT TARGET xorg::xorg)
    add_library(xorg::xorg INTERFACE IMPORTED)
endif()

# Load the debug and release library finders
get_filename_component(_DIR "${CMAKE_CURRENT_LIST_FILE}" PATH)
file(GLOB CONFIG_FILES "${_DIR}/xorgTarget-*.cmake")

foreach(f ${CONFIG_FILES})
    include(${f})
endforeach()

if(xorg_FIND_COMPONENTS)
    foreach(_FIND_COMPONENT ${xorg_FIND_COMPONENTS})
        list(FIND xorg_COMPONENTS_RELEASE "xorg::${_FIND_COMPONENT}" _index)
        if(${_index} EQUAL -1)
            conan_message(FATAL_ERROR "Conan: Component '${_FIND_COMPONENT}' NOT found in package 'xorg'")
        else()
            conan_message(STATUS "Conan: Component '${_FIND_COMPONENT}' found in package 'xorg'")
        endif()
    endforeach()
endif()