cmake_minimum_required (VERSION 3.13.0)
set (CMAKE_CXX_STANDARD 20)
set (CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/bin")

project (hello-allegro VERSION 1.0.0)

include (FetchContent)
set (FETCH FALSE)

find_library (allegro allegro REQUIRED)
if (allegro STREQUAL "allegro-NOTFOUND")
    message (STATUS "missing library: allegro")
    set (FETCH TRUE)
endif ()

find_library (allegro_main allegro_main REQUIRED)
if (allegro_main STREQUAL "allegro_main-NOTFOUND")
    message (STATUS "missing library: allegro_main")
    set (FETCH TRUE)
endif ()

find_library (allegro_font allegro_font REQUIRED)
if (allegro_font STREQUAL "allegro_font-NOTFOUND")
    message (STATUS "missing library: allegro_font")
    set (WANT_FONT ON CACHE INTERNAL "")
    set (FETCH TRUE)
else ()
    set (WANT_FONT OFF CACHE INTERNAL "")
endif ()

find_library (allegro_ttf allegro_ttf REQUIRED)
if (allegro_ttf STREQUAL "allegro_ttf-NOTFOUND")
    message (STATUS "missing library: allegro_ttf")
    set (WANT_TTF ON CACHE INTERNAL "")
    set (FETCH TRUE)
else ()
    set (WANT_TTF OFF CACHE INTERNAL "")
endif ()

#[[
find_library (allegro_audio allegro_audio)
if (allegro_audio STREQUAL "allegro_audio-NOTFOUND")
    message (STATUS "missing library: allegro_audio")
    set (WANT_AUDIO ON CACHE INTERNAL "")
    set (FETCH TRUE)
else ()
    set (WANT_AUDIO OFF CACHE INTERNAL "")
endif ()
]]

#[[
find_library (allegro_image allegro_image)
if (allegro_image STREQUAL "allegro_image-NOTFOUND")
    message (STATUS "missing library: allegro_image")
    set (WANT_IMAGE ON CACHE INTERNAL "")
    set (FETCH TRUE)
else ()
    set (WANT_IMAGE OFF CACHE INTERNAL "")
endif ()
]]

find_library (allegro_color allegro_color)
if (allegro_color STREQUAL "allegro_color-NOTFOUND")
    message (STATUS "missing library: allegro_color")
    set (WANT_COLOR ON CACHE INTERNAL "")
    set (FETCH TRUE)
else ()
    set (WANT_COLOR OFF CACHE INTERNAL "")
endif ()

#[[
find_library (allegro_memfile allegro_memfile)
if (allegro_memfile STREQUAL "allegro_memfile-NOTFOUND")
    message (STATUS "missing library: allegro_memfile")
    set (WANT_MEMFILE ON CACHE INTERNAL "")
    set (FETCH TRUE)
else ()
    set (WANT_MEMFILE OFF CACHE INTERNAL "")
endif ()
]]

#[[
find_library (allegro_physfs allegro_physfs)
if (allegro_physfs STREQUAL "allegro_physfs-NOTFOUND")
    message (STATUS "missing library: allegro_physfs")
    set (WANT_PHYSFS ON CACHE INTERNAL "")
    set (FETCH TRUE)
else ()
    set (WANT_PHYSFS OFF CACHE INTERNAL "")
endif ()
]]

#[[
find_library (allegro_primitives allegro_primitives)
if (allegro_primitives STREQUAL "allegro_primitives-NOTFOUND")
    message (STATUS "missing library: allegro_primitives")
    set (WANT_PRIMITIVES ON CACHE INTERNAL "")
    set (FETCH TRUE)
else ()
    set (WANT_PRIMITIVES OFF CACHE INTERNAL "")
endif ()
]]

find_library (allegro_dialog allegro_dialog)
if (allegro_dialog STREQUAL "allegro_dialog-NOTFOUND")
    message (STATUS "missing library: allegro_dialog")
    set (WANT_NATIVE_DIALOG  ON CACHE INTERNAL "")
    set (FETCH TRUE)
else ()
    set (WANT_NATIVE_DIALOG OFF CACHE INTERNAL "")
endif ()

#[[
find_library (allegro_video allegro_video)
if (allegro_video STREQUAL "allegro_video-NOTFOUND")
    message (STATUS "missing library: allegro_video")
    set (WANT_VIDEO ON CACHE INTERNAL "")
    set (FETCH TRUE)
else ()
    set (WANT_VIDEO OFF CACHE INTERNAL "")
endif ()
]]

if (FETCH)
    message (STATUS "Fetching missing libraries...")
    set (CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}" CACHE INTERNAL "") # prevent installing to system directories
    FetchContent_Declare(
        allegro
        GIT_REPOSITORY https://github.com/liballeg/Allegro5.git
        GIT_TAG 5.2.10.1
        FIND_PACKAGE_ARGS
    )
    set (WANT_EXAMPLES OFF CACHE INTERNAL "")
    set (WANT_DEMO OFF CACHE INTERNAL "")
    set (WANT_TESTS OFF CACHE INTERNAL "")
    FetchContent_MakeAvailable(allegro)
endif ()

add_executable (${PROJECT_NAME})

add_subdirectory (src)

target_link_libraries (
    ${PROJECT_NAME}
    PUBLIC allegro
    PUBLIC allegro_main
    PUBLIC allegro_font
    PUBLIC allegro_ttf
    PUBLIC allegro_color
)
