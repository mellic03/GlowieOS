#pragma once

namespace knl::init
{
    bool serial();
}

namespace knl::serial
{
    void putch(char);
    void putstr(const char*);
}
