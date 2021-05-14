# From https://github.com/lefticus/cppbestpractices/blob/master/02-Use_the_Tools_Available.md#compilers

set(MSVC_WARNINGS
    /W4 # Baseline reasonable warnings
    # /Wall # Also warns on files included from the standard library, so it's not very useful and creates too many extra warnings.
    /w14242 # 'identifier': conversion from 'type1' to 'type1', possible loss of data
    /w14254 # 'operator': conversion from 'type1:field_bits' to 'type2:field_bits', possible loss of data
    /w14263 # 'function': member function does not override any base class virtual member function
    /w14265 # 'classname': class has virtual functions, but destructor is not virtual instances of this class may not be destructed correctly
    /w14287 # 'operator': unsigned/negative constant mismatch
    /we4289 # nonstandard extension used: 'variable': loop control variable declared in the for-loop is used outside the for-loop scope
    /w14296 # 'operator': expression is always 'boolean_value'
    /w14311 # 'variable': pointer truncation from 'type1' to 'type2'
    /w14545 # expression before comma evaluates to a function which is missing an argument list
    /w14546 # function call before comma missing argument list
    /w14547 # 'operator': operator before comma has no effect; expected operator with side-effect
    /w14549 # 'operator': operator before comma has no effect; did you intend 'operator'?
    /w14555 # expression has no effect; expected expression with side- effect
    /w14619 # pragma warning: there is no warning number 'number'
    /w14640 # Enable warning on thread un-safe static member initialization
    /w14826 # Conversion from 'type1' to 'type_2' is sign-extended. This may cause unexpected runtime behavior.
    /w14905 # wide string literal cast to 'LPSTR'
    /w14906 # string literal cast to 'LPWSTR'
    /w14928 # illegal copy-initialization; more than one user-defined conversion has been implicitly applied
)


set(CLANG_WARNINGS
    -Wall
    -Wextra # reasonable and standard
    -Wshadow # warn the user if a variable declaration shadows one from a parent context, may cause warnings in 3rd party libs
    -Wnon-virtual-dtor # warn the user if a class with virtual functions has a non-virtual destructor. This helps catch hard to track down memory errors
    -Wold-style-cast # warn for c-style casts
    -Wcast-align # warn for potential performance problem casts
    -Wunused # warn on anything being unused
    -Woverloaded-virtual # warn if you overload (not override) a virtual function
    -Wconversion # warn on type conversions that may lose data
    -Wsign-conversion # warn on sign conversions
    -Wnull-dereference # warn if a null dereference is detected
    -Wdouble-promotion # warn if float is implicit promoted to double
    -Wformat=2 # warn on security issues around functions that format output (ie printf)
)

set(GCC_WARNINGS
    ${CLANG_WARNINGS}
    -Wmisleading-indentation # warn if indentation implies blocks where blocks do not exist
    -Wduplicated-cond # warn if if / else chain has duplicated conditions
    -Wduplicated-branches # warn if if / else branches have duplicated code
    -Wlogical-op # warn about logical operations being used where bitwise were probably wanted
    -Wuseless-cast # warn if you perform a cast to the same type
)

# Defining a macro requires its invocation separate from the inclusion of this file, but allows it to be done after including and building any 3rd party libs, etc. Top-down directory scoping will apply it to any targets thereafter.
macro(enable_warnings)
    # Using a conditional generator expresssion of the form $<$<CXX_COMPILER_ID:MSVC>:"${MSVC_WARNINGS}"> is tricky
    # ${MSVC_WARNINGS} must then be a string and some contortion would be required to make it play nicely with
    # add_compile_options. It's easier to just do it the old fashioned way.
    if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
        add_compile_options(${GCC_WARNINGS})
    elseif("${CMAKE_CXX_COMPILER_ID}" MATCHES "Clang") # Clang or AppleClang
        add_compile_options(${CLANG_WARNINGS})
    elseif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
        add_compile_options(${MSVC_WARNINGS})
    endif()

    if(NOT "$ENV{DISABLE_WERROR}")
        add_compile_options($<$<CXX_COMPILER_ID:MSVC>:/WX>)
        add_compile_options($<$<CXX_COMPILER_ID:Clang>:-Werror>)
        add_compile_options($<$<CXX_COMPILER_ID:AppleClang>:-Werror>)
        add_compile_options($<$<CXX_COMPILER_ID:GNU>:-Werror>)
    endif()
endmacro()
