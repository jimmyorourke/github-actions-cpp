#include <simple_math/simple_math.hpp>

#include <iostream>

namespace simple_math {

int add(int a, int b) {
    std::cout << "Adding " << a << " and " << b << "\n";
    return a + b;
}

int multiply(int a, int b) {
    std::cout << "Multiplying " << a << " and " << b << "\n";
    return a * b;
}

}
