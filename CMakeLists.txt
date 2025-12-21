cmake_minimum_required(VERSION 3.28)

string(ASCII 27 Esc)
set(Green "${Esc}[32m")
set(CMAKE_COLOR_DIAGNOSTICS ON)

project(GlowBigga)
ENABLE_LANGUAGE(ASM_NASM)

# set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/sysroot/usr/lib")
# set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/sysroot/usr/lib")
# set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/sysroot/usr/bin")
# set(CMAKE_STATIC_LIBRARY_PREFIX "")
# set(CMAKE_SHARED_LIBRARY_PREFIX "")

# include(${CMAKE_SOURCE_DIR}/cmake-config.cmake)


# # add_compile_definitions("-D__is_kernel")
# add_subdirectory("${CMAKE_SOURCE_DIR}/lib/libc/")
# add_subdirectory("${CMAKE_SOURCE_DIR}/lib/libc++/")
add_subdirectory("${CMAKE_SOURCE_DIR}/kernel/")