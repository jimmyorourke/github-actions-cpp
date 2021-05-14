add_executable(test_simple_math test_simple_math.cpp)
target_link_libraries(test_simple_math
    PRIVATE
        simple_math
        CONAN_PKG::gtest
)

add_test(NAME test_simple_math
    COMMAND test_simple_math
)
