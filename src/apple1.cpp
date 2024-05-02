#include <cstdio>
#include <cstring>
#include <cctype>
#include <thread>
#include <chrono>
#include <fstream>
#include <deque>

#ifdef _WIN32
#include <windows.h>
#include <fcntl.h>
#include <io.h>
#else
#include <termios.h>
#endif

extern "C" {
#include "m6502.h"
}

static const uint8_t woz[] = {
    0xd8, 0x58, 0xa0, 0x7f, 0x8c, 0x12, 0xd0, 0xa9, 0xa7, 0x8d, 0x11, 0xd0,
    0x8d, 0x13, 0xd0, 0xc9, 0xdf, 0xf0, 0x13, 0xc9, 0x9b, 0xf0, 0x03, 0xc8,
    0x10, 0x0f, 0xa9, 0xdc, 0x20, 0xef, 0xff, 0xa9, 0x8d, 0x20, 0xef, 0xff,
    0xa0, 0x01, 0x88, 0x30, 0xf6, 0xad, 0x11, 0xd0, 0x10, 0xfb, 0xad, 0x10,
    0xd0, 0x99, 0x00, 0x02, 0x20, 0xef, 0xff, 0xc9, 0x8d, 0xd0, 0xd4, 0xa0,
    0xff, 0xa9, 0x00, 0xaa, 0x0a, 0x85, 0x2b, 0xc8, 0xb9, 0x00, 0x02, 0xc9,
    0x8d, 0xf0, 0xd4, 0xc9, 0xae, 0x90, 0xf4, 0xf0, 0xf0, 0xc9, 0xba, 0xf0,
    0xeb, 0xc9, 0xd2, 0xf0, 0x3b, 0x86, 0x28, 0x86, 0x29, 0x84, 0x2a, 0xb9,
    0x00, 0x02, 0x49, 0xb0, 0xc9, 0x0a, 0x90, 0x06, 0x69, 0x88, 0xc9, 0xfa,
    0x90, 0x11, 0x0a, 0x0a, 0x0a, 0x0a, 0xa2, 0x04, 0x0a, 0x26, 0x28, 0x26,
    0x29, 0xca, 0xd0, 0xf8, 0xc8, 0xd0, 0xe0, 0xc4, 0x2a, 0xf0, 0x97, 0x24,
    0x2b, 0x50, 0x10, 0xa5, 0x28, 0x81, 0x26, 0xe6, 0x26, 0xd0, 0xb5, 0xe6,
    0x27, 0x4c, 0x44, 0xff, 0x6c, 0x24, 0x00, 0x30, 0x2b, 0xa2, 0x02, 0xb5,
    0x27, 0x95, 0x25, 0x95, 0x23, 0xca, 0xd0, 0xf7, 0xd0, 0x14, 0xa9, 0x8d,
    0x20, 0xef, 0xff, 0xa5, 0x25, 0x20, 0xdc, 0xff, 0xa5, 0x24, 0x20, 0xdc,
    0xff, 0xa9, 0xba, 0x20, 0xef, 0xff, 0xa9, 0xa0, 0x20, 0xef, 0xff, 0xa1,
    0x24, 0x20, 0xdc, 0xff, 0x86, 0x2b, 0xa5, 0x24, 0xc5, 0x28, 0xa5, 0x25,
    0xe5, 0x29, 0xb0, 0xc1, 0xe6, 0x24, 0xd0, 0x02, 0xe6, 0x25, 0xa5, 0x24,
    0x29, 0x07, 0x10, 0xc8, 0x48, 0x4a, 0x4a, 0x4a, 0x4a, 0x20, 0xe5, 0xff,
    0x68, 0x29, 0x0f, 0x09, 0xb0, 0xc9, 0xba, 0x90, 0x02, 0x69, 0x06, 0x2c,
    0x12, 0xd0, 0x30, 0xfb, 0x8d, 0x12, 0xd0, 0x60, 0x00, 0x00, 0x00, 0x0f,
    0x00, 0xff, 0x00, 0x00,
};

class apple1
{
public:
    apple1()
    {
        m6502_init(&cpu);
        cpu.userdata = this;
        cpu.read_byte = [](void* userdata, uint16_t addr)
        {
            return ((apple1*)userdata)->read(addr);
        };
        cpu.write_byte = [](void* userdata, uint16_t addr, uint8_t byte)
        {
            ((apple1*)userdata)->write(addr, byte);
        };

        mem = new uint8_t[65536]{0};
        memcpy(&mem[0xff00], woz, sizeof(woz));
    }

    ~apple1()
    {
        delete mem;
    }

    void run()
    {
#ifdef _WIN32
        DWORD mode;
        HANDLE h = GetStdHandle(STD_INPUT_HANDLE);
        GetConsoleMode(h, &mode);
        mode &= ~ENABLE_ECHO_INPUT;
        mode &= ~ENABLE_LINE_INPUT;
        SetConsoleMode(h, mode);
        setmode(0, O_BINARY);
#else
#error "Linux version to be implemented"
#endif

        std::thread([this](){
            while(true)
            {
                uint8_t byte = getchar();
                byte = toupper(byte) | 0x80;
                keys.push_back(byte);
            }
        }).detach();

        m6502_gen_res(&cpu);
        while (true)
        {
            m6502_step(&cpu);
            // detect LDA KBD; BPL xxx (it's a snippet
            // through which WOZ Monitor and BASIC read
            // the key inputs.) and sleep for a little
            // while if the branch xxx will be taken.
            uint8_t ops[] = { 0xAD, 0x11, 0xD0, 0x10 };
            if (!memcmp(&mem[cpu.pc-3], ops, 4) && !cpu.nf)
            {
                std::this_thread::sleep_for(
                    std::chrono::milliseconds(20));
            }
        }
    }

private:
    static constexpr uint16_t KBD = 0xD010;
    static constexpr uint16_t KBDCR = 0xD011;
    static constexpr uint16_t DSP = 0xD012;

    uint8_t read(uint16_t addr)
    {
        // if page == 0xD0
        // AND offset with 0x13
        // this emulates 'incomplete decode'
        // there are 6 versions of Apple I BASIC,
        // 5 of which need this feature to run.
        // Why AND the offset with 0x13? I don't know. I just copied it from https://github.com/whscullin/apple1js/blob/main/js/apple1io.ts
        // About 6 versions of Apple I BASIC: https://apple1notes.com/?page_id=42
        // About incomplete decode, I asked Eric Smith, who disassemled Apple 1 BASIC (source code: https://github.com/brouhaha/a1basic/blob/master/a1basic.asm)
        // Eric Smith:
        // The general concept of incomplete decode is that the hardware on the PCB (not in the 6502 itself) doesn't decode all chip selects down to the smallest possible size. This can result in "mirroring", where some memory devices or I/O registers appear at inultiple distinct addresses in the memory map.
        // In some hardware designs, more than one memory or device might respond to an alternate address, causing bus contention, but that should not happen at the "standard" address.
        // Incomplete decode was more commonly found in 1970s and early 1980s designs, to reduce the count of 7400-series TTL chips in the design, and/or to speed up decoding by having fewer levels of logic.
        // In the Apple 1, the PIA addresses are not fully decoded, such that d012 and d0f2 (as well as many other addresses) correspond to the same register. Changing d0f2 to d012 in the source code should still work. However, if the emulator you're writing is intended to run Apple 1 software unmodified, you may need to emulate the incomplete decode.
        if ((addr >> 8) == 0xD0)
            addr &= 0xFF13;

        switch(addr)
        {
        case KBD:
            if (!keys.empty())
            {
                mem[KBD] = keys.front();
                keys.pop_front();
            }
            break;
        case KBDCR:
            mem[KBDCR] = keys.empty() ? 0x00 : 0x80;
            break;
        }
        return mem[addr];
    }

    void write(uint16_t addr, uint8_t byte)
    {
        if ((addr >> 8) == 0xD0)
            addr &= 0xFF13;

        switch(addr)
        {
        case KBD:
            break;
        case KBDCR:
            break;
        case DSP:
            byte &= 0x7f;
            byte = toupper(byte);
            putchar(byte == '\r' ? '\n' : byte);
            // no break
        default:
            mem[addr] = byte;
            break;
        }
    }

public:
    m6502 cpu;
    uint8_t* mem;
    std::deque<char> keys;
};

int main(int argc, char** argv)
{
    apple1 ap1;
    for (int i = 1; i < argc; i++)
    {
        // binary loader, see build.ninja for more details
        std::ifstream file(argv[i], std::ios::binary);
        if (!file.is_open())
        {
            printf("no such file %s\n", argv[1]);
            return -1;
        }

        file.seekg(0, std::ios::end);
        size_t size = file.tellg();
        file.seekg(0);

        while (file.tellg() < size)
        {
            uint16_t org, len;
            file.read((char*)&org, 2);
            file.read((char*)&len, 2);
            file.read((char*)&ap1.mem[org], len);
        }
    }
    ap1.run();
}
