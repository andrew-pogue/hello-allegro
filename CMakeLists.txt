cmake_minimum_required (VERSION 3.19.0)
set (CMAKE_CXX_STANDARD 20)
set (CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/bin)
list (APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

option (BUILD_ALLEGRO "build Allegro locally from source" OFF)
option (USE_SHARED_ALLEGRO "use shared Allegro libraries" OFF)

project (hello-allegro VERSION 1.0.0 LANGUAGES CXX)

if (BUILD_ALLEGRO)
    include (cmake/BuildAllegro.cmake)
else ()
    find_package (Allegro 5.2 REQUIRED COMPONENTS main font ttf primitives color image)
endif ()

add_executable (${PROJECT_NAME})

add_dependencies (${PROJECT_NAME} allegro::allegro)

target_link_libraries (
    ${PROJECT_NAME}
    PRIVATE allegro::allegro
    PRIVATE allegro::main
    PRIVATE allegro::font
    PRIVATE allegro::ttf
    PRIVATE allegro::primitives
    PRIVATE allegro::color
    PRIVATE allegro::image
)

add_subdirectory (src)

