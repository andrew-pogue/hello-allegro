cmake_minimum_required (VERSION 3.19.0)
set (CMAKE_CXX_STANDARD 20)
set (CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/bin)
list (APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

option (USE_STATIC_ALLEGRO "use static Allegro libraries" OFF)

project (hello-allegro VERSION 1.0.0 LANGUAGES CXX)

find_package (Allegro 5.2 REQUIRED COMPONENTS main font ttf primitives color image)

add_executable (${PROJECT_NAME})

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

