#[[
will always look all the addons
missing an addon will be fatal if its specified as a required component
valid components are: main font ttf color image audio acodec video primitives memfile physfs dialog
]]

include (util)

find_path (Allegro_INCLUDE_DIR "allegro5/allegro.h")
if (Allegro_INCLUDE_DIR)

    file (READ "${Allegro_INCLUDE_DIR}/allegro5/base.h" header)
    get_int_from_header (header ALLEGRO_VERSION Allegro_VERSION_MAJOR)
    get_int_from_header (header ALLEGRO_SUB_VERSION Allegro_VERSION_MINOR)
    get_int_from_header (header ALLEGRO_WIP_VERSION Allegro_VERSION_PATCH)
    set (Allegro_VERSION "${Allegro_VERSION_MAJOR}.${Allegro_VERSION_MINOR}.${Allegro_VERSION_PATCH}")

    is_valid_version (Allegro Allegro_FOUND)
    if (Allegro_FOUND)
        message (STATUS "Found Allegro ${Allegro_VERSION}")
    else ()
        if (Allegro_FIND_REQUIRED) 
            message (FATAL_ERROR "Invalid Allegro version: ${Allegro_VERSION}")
        elseif (NOT Allegro_FIND_QUIETLY)
            message (STATUS "Invalid Allegro version: ${Allegro_VERSION}")
        endif ()
        return ()
    endif ()

    if (USE_SHARED_ALLEGRO)
        message (STATUS "Looking for Allegro's shared libraries...")
        set (type SHARED)
        set (suffix "")
    else ()
        message (STATUS "Looking for Allegro's static libraries...")
        set (suffix "-static")
        set (type STATIC)
    endif ()

    if (NOT TARGET allegro::allegro)
        find_library (allegro_lib allegro${suffix})
        if (NOT allegro_lib)
            if (Allegro_FIND_REQUIRED) 
                message (FATAL_ERROR "Missing Allegro core library.")
            elseif (NOT Allegro_FIND_QUIETLY)
                message (STATUS "Missing Allegro core library.")
            endif ()
            set (Allegro_FOUND FALSE)
            return ()
        endif ()
        get_filename_component(Allegro_LIBRARY_DIR "${allegro_lib}" DIRECTORY)
        list (APPEND Allegro_LIBRARIES ${allegro_lib})
        add_library (allegro::allegro ${type} IMPORTED GLOBAL)
        set_target_properties (
            allegro::allegro PROPERTIES
            IMPORTED_LOCATION ${allegro_lib}
            INTERFACE_INCLUDE_DIRECTORIES ${Allegro_INCLUDE_DIR}
        )
    endif ()

    foreach (addon main font ttf color image audio acodec video primitives memfile physfs dialog)
        if (TARGET allegro::${addon})
            continue ()
        endif ()

        find_library (allegro_lib_${addon} allegro_${addon}${suffix})
        if (NOT allegro_lib_${addon})
            if (Allegro_FIND_REQUIRED_${addon}) 
                message (FATAL_ERROR "Missing Allegro ${addon} addon.")
            elseif (NOT Allegro_FIND_QUIETLY)
                message (STATUS "Missing Allegro ${addon} addon.")
            endif ()
            continue ()
        endif ()
        list (APPEND Allegro_LIBRARIES ${allegro_lib_${addon}})

        add_library (allegro::${addon} ${type} IMPORTED GLOBAL)
        set_target_properties (
            allegro::${addon} PROPERTIES
            IMPORTED_LOCATION ${allegro_lib_${addon}}
            INTERFACE_INCLUDE_DIRECTORIES ${Allegro_INCLUDE_DIR}
        )
    endforeach ()

    if (NOT TARGET allegro::full)
        add_library (allegro::full INTERFACE IMPORTED GLOBAL)
        target_link_libraries (allegro::full INTERFACE allegro::allegro)
        foreach (addon main font ttf color image audio acodec video primitives memfile physfs dialog)
            target_link_libraries (allegro::full INTERFACE allegro::${addon})
        endforeach ()
    endif ()

    mark_as_advanced (header)
    mark_as_advanced (allegro_lib)
    foreach (addon main font ttf color image audio acodec video primitives memfile physfs dialog)
        mark_as_advanced (allegro_lib_${addon})
    endforeach ()
    mark_as_advanced (suffix)
endif ()
