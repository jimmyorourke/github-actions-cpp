add_library(simple_math
    src/simple_math.cpp
)

target_include_directories(simple_math
    PUBLIC
        include
)

add_subdirectory(test)
