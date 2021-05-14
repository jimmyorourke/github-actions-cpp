cmake_minimum_required(VERSION 3.12)

project(simple_math)


include(cmake/ConanSetup.cmake)
include(cmake/DefaultConfiguration.cmake)
include(cmake/Warnings.cmake)
enable_warnings()


add_subdirectory(libsimple_math)

add_executable(do_simple_math
    main.cpp
)
target_link_libraries(do_simple_math
    PRIVATE
        simple_math
)

install(TARGETS do_simple_math DESTINATION bin)
