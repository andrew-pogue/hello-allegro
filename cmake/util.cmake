function (print)
    foreach (var ${ARGN})
        message ("${var} = ${${var}}")
    endforeach ()
endfunction ()

macro (is_valid_version name result)
    set (${result} TRUE)
    if (DEFINED ${name}_FIND_VERSION_RANGE)
        if (${${name}_VERSION} VERSION_GREATER ${${name}_FIND_VERSION_MAX} OR
            ${${name}_VERSION} VERSION_LESS ${${name}_FIND_VERSION_MIN} OR
            (${${name}_VERSION} VERSION_EQUAL ${${name}_FIND_VERSION_MAX} AND ${${name}_FIND_VERSION_RANGE_MAX} STREQUAL "EXCLUDE"))
            set (${result} FALSE)
        endif ()
    elseif (${${name}_VERSION} VERSION_LESS ${${name}_FIND_VERSION})
        set (${result} FALSE)
    endif ()
endmacro ()

macro (get_int_from_header header cmacro result)
    string (REGEX MATCH "#define ${cmacro}[ \t]+([0-9]+)" _ "${${header}}")
    set (${result} "${CMAKE_MATCH_1}")
endmacro ()
