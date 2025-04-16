set (Allegro_VERSION 5.2.10.1)
message (STATUS "Configuring Allegro (${Allegro_VERSION})...")

include(ExternalProject)
ExternalProject_Add(
    Allegro
    GIT_REPOSITORY      https://github.com/liballeg/Allegro5.git
    GIT_TAG             ${Allegro_VERSION}
    PREFIX              ${CMAKE_BINARY_DIR}/_deps/allegro
    CMAKE_ARGS          
        -DSHARED=${USE_SHARED_ALLEGRO}
        -DWANT_EXAMPLES=OFF
        -DWANT_TESTS=OFF
        -DWANT_DOCS=OFF
        -DWANT_DEMO=OFF
        -DWANT_X11=OFF
        -DWANT_D3D=ON
        -DWANT_OPENGL=OFF
        -DWANT_MONOLITH=OFF
        -DWANT_MAIN=ON
        -DWANT_COLOR=ON
        -DWANT_PRIMITIVES=ON
        -DWANT_FONT=ON
        -DWANT_TTF=ON
        -DWANT_IMAGE=ON
        -DWANT_AUDIO=ON
        -DWANT_ACODEC=ON
        -DWANT_VIDEO=ON
        -DWANT_MEMFILE=ON
        -DWANT_PHSYFS=ON
        -DWANT_NATIVE_DIALOG=ON
        -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
    UPDATE_DISCONNECTED TRUE
    INSTALL_DIR         ${CMAKE_BINARY_DIR}/_install/allegro
)
ExternalProject_Get_Property (Allegro INSTALL_DIR)

if (USE_SHARED_ALLEGRO)
    set (type SHARED)
    set (prefix ${CMAKE_SHARED_LIBRARY_PREFIX})
    set (suffix ${CMAKE_SHARED_LIBRARY_SUFFIX})
else ()
    set (type STATIC)
    set (prefix ${CMAKE_STATIC_LIBRARY_PREFIX})
    set (suffix -static${CMAKE_STATIC_LIBRARY_SUFFIX})
endif ()

add_library (allegro::allegro ${type} IMPORTED GLOBAL)
add_dependencies (allegro::allegro Allegro)
set_target_properties (
    allegro::allegro PROPERTIES
    IMPORTED_LOCATION "${INSTALL_DIR}/lib/${prefix}allegro${suffix}"
    INCLUDE_DIRECTORIES "${INSTALL_DIR}/include"
)

add_library (allegro::full INTERFACE IMPORTED GLOBAL)
target_link_libraries (allegro::full INTERFACE allegro::allegro)

foreach (addon main font ttf color image audio acodec video primitives memfile physfs dialog)
    add_library (allegro::${addon} ${type} IMPORTED GLOBAL)
    add_dependencies (allegro::${addon} Allegro)
    set_target_properties (
        allegro::${addon} PROPERTIES
        IMPORTED_LOCATION "${INSTALL_DIR}/lib/${prefix}allegro_${addon}${suffix}"
        INCLUDE_DIRECTORIES "${INSTALL_DIR}/include"
    )
    target_link_libraries (allegro::full INTERFACE allegro::${addon})
endforeach ()

mark_as_advanced (suffix)
mark_as_advanced (prefix)
