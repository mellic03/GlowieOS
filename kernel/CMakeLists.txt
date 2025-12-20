
file(GLOB SOURCES
    "${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/${__kernel_arch__}*.cpp"
)

add_executable(
    kernel.elf ${SOURCES}
)

target_compile_options(
    kernel.elf PRIVATE "$<$<COMPILE_LANGUAGE:CXX>:${FLAGS_COMPILE_DEFAULT}>"
)

target_link_options(
    kernel.elf PRIVATE "$<$<COMPILE_LANGUAGE:CXX>:${FLAGS_LINK_DEFAULT}>"
)


if (DEFINED ENV{__kernel_arch__})
    ENV{__kernel_arch__}
endif()

include_directories("${CMAKE_SOURCE_DIR}/kernel/include/")
include_directories("${CMAKE_SOURCE_DIR}/kernel/include/arch/x86_64/")
include_directories("${CMAKE_SOURCE_DIR}/include/")

target_link_libraries(
    kernel.elf PRIVATE
    klibc
    klibc++
    knl_cpu
    knl_syslog
    knl_wm
)