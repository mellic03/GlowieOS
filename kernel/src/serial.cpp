#include <arch/io.hpp>
#include <kernel/serial.hpp>

void knl::serial::putch(char ch)
{
    IO::out8(IO::COM1, ch);
}

void knl::serial::putstr(const char *str)
{
    while (char ch = *(str++))
    {
        IO::out8(IO::COM1, ch);
    }
}
