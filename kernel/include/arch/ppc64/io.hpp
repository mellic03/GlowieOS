#pragma once

#include <stddef.h>
#include <stdint.h>

namespace knl::IO
{
    static constexpr uint16_t COM1 = 0x3F8;
    static constexpr uint16_t COM2 = 0x2F8;
    static constexpr uint16_t COM3 = 0x3E8;
    static constexpr uint16_t COM4 = 0x2E8;
    static constexpr uint16_t COM5 = 0x5F8;
    static constexpr uint16_t COM6 = 0x4F8;
    static constexpr uint16_t COM7 = 0x5E8;
    static constexpr uint16_t COM8 = 0x4E8;

    bool init();

    inline uint8_t in8( uint16_t port )
    {
        uint8_t value = 0;
        return value;
    }

    inline uint16_t in16( uint16_t port )
    {
        uint16_t value = 0;
        return value;
    }

    inline uint32_t in32( uint16_t port )
    {
        uint32_t value = 0;
        return value;
    }

    inline void out8( uint16_t port, uint8_t value )
    {
        if (port || value) {  }
    }

    inline void out16( uint16_t port, uint16_t value )
    {
        if (port || value) {  }
    }

    inline void out32( uint16_t port, uint32_t value )
    {
        if (port || value) {  }
    }

    inline void wait()
    {
        IO::out8(0x80, 0);
    }

    // template <typename uintxx_t>
    // inline uintxx_t inxx( uint16_t port );

    // template<> inline uint8_t inxx<uint8_t>( uint16_t port )
    // { uint8_t v; __asm__ volatile ("inb %1, %0" : "=a"(v) : "Nd"(port)); return v; }

    // template<> inline uint16_t inxx<uint16_t>( uint16_t port )
    // { uint16_t v; __asm__ volatile ("inw %1, %0" : "=a"(v) : "Nd"(port)); return v; }

    // template<> inline uint32_t inxx<uint32_t>( uint16_t port )
    // { uint32_t v; __asm__ volatile ("inl %w1,%0":"=a" (v):"Nd" (port)); return v; }


    // template <typename uintxx_t>
    // inline void outxx( uint16_t port, uintxx_t value );

    // template<> inline void outxx<uint8_t>( uint16_t port, uint8_t value )
    // { __asm__ volatile("outb %0, %1" : : "a"(value), "Nd"(port)); }

    // template<> inline void outxx<uint16_t>( uint16_t port, uint16_t value )
    // { __asm__ volatile("outw %0, %1" : : "a"(value), "Nd"(port)); }

    // template<> inline void outxx<uint32_t>( uint16_t port, uint32_t value )
    // { __asm__ volatile("outl %0, %w1" : : "a"(value), "Nd"(port)); }

    // const auto in8  = IO::inxx<uint8_t>;
    // const auto in16 = IO::inxx<uint16_t>;
    // const auto in32 = IO::inxx<uint32_t>;

    // const auto out8  = IO::outxx<uint8_t>;
    // const auto out16 = IO::outxx<uint16_t>;
    // const auto out32 = IO::outxx<uint32_t>;

}