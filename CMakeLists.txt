cmake_minimum_required(VERSION 3.12)

project(simple)

set(CMAKE_NO_SYSTEM_FROM_IMPORTED ON)
cmake_policy(SET CMP0063 NEW)
set(CMAKE_CXX_VISIBILITY_PRESET hidden)


if (CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
    set(CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/install/" CACHE PATH "Installation path" FORCE)
endif()

# Enable colour
if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
   add_compile_options (-fdiagnostics-color=always)
elseif ("${CMAKE_CXX_COMPILER_ID}" MATCHES "Clang")
   add_compile_options (-fcolor-diagnostics)
endif ()

# Set C/C++ standards
set(CMAKE_C_STANDARD 99)
set(CMAKE_C_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_EXTENSIONS OFF)

enable_testing() # enable CTEST

if(EXISTS "${CMAKE_BINARY_DIR}/conanbuildinfo.cmake")
    include(${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
else()
    message(FATAL_ERROR "Error: could not find conanbuildinfo.cmake.
To fix this, do the following:
* Delete CMakeCache.txt:
    rm CMakeCache.txt (macOS, Linux)
    del CMakeCache.txt (Windows)
* Run conan to install needed dependencies:
    conan install ..
* Run CMake generation again:
    cmake -G Ninja [any other desired options] ..")
endif()
conan_basic_setup(TARGETS NO_OUTPUT_DIRS KEEP_RPATHS)

if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU" OR "${CMAKE_CXX_COMPILER_ID}" MATCHES "Clang")
    # enable some most common/useful warnings and turn on warnings as errors
    add_compile_options(
        -Werror
        -Wall
        -Wextra
        -Wnull-dereference
        -Wold-style-cast
        #-Wuseless-cast
        #-Wduplicated-cond
        #-Wduplicated-branches
        #-Wlogical-op
        #-Wrestrict
        # This may cause warnings in 3rd party libs needing suppression, or we might get by with -Wshadow=compatible-local
        -Wshadow
        )
endif()

# Set a default build type if none was specified
set(default_build_type "Release")
if(EXISTS "${CMAKE_SOURCE_DIR}/.git")
  set(default_build_type "Debug")
endif()

if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  message(STATUS "Setting build type to RelWithDebInfo as none was specified.")
  set(CMAKE_BUILD_TYPE RelWithDebInfo CACHE
      STRING "Choose the type of build." FORCE)
  # Set the possible values of build type for cmake-gui
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS
    "Debug" "Release" "MinSizeRel" "RelWithDebInfo")
endif()

add_library(simple_math
    simple_math.cpp
)
target_include_directories(simple_math
    PUBLIC
        .
)

add_executable(hello
    main.cpp
)
target_link_libraries(hello
    PRIVATE
        simple_math
)

add_executable(test_simple_math test_simple_math.cpp)
target_link_libraries(test_simple_math
    PRIVATE
        simple_math
        CONAN_PKG::gtest
)
add_test(NAME test_simple_math
    COMMAND test_simple_math
)


