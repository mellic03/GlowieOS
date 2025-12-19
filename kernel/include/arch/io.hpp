#pragma once

#ifndef GLOWIE_ARCH
    #error GLOWIE_ARCH must be defined!
#endif

#define STR(A) #A
#define CONCAT(n1, n2) STR(n1/n2)

#include CONCAT(GLOWIE_ARCH, io.hpp)
