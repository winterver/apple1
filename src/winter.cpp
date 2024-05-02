#include <cstdio>
#include <cstring>
#include <cctype>
#include <thread>
#include <mutex>
#include <condition_variable>
#include <fstream>

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

class condition
{
public:
    void wait()
    {
        std::unique_lock<std::mutex> lk(mtx);
        cv.wait(lk);
    }

    void notify()
    {
        cv.notify();
    }
private:
    std::mutex mtx;
    std::condition_variable cv;
};

class winter
{
    static constexpr uint16_t IO = 0xD000;

public:
    winter()
        : mem(new uint8_t[65536]{0})
    {
        m6502_init(&cpu);
        cpu.m65c02_mode = 1;
        cpu.userdata = this;
        cpu.read_byte = [](void* userdata, uint16_t addr)
        {
            return ((winter*)userdata)->mem[addr];
        };
        cpu.write_byte = [](void* userdata, uint16_t addr, uint8_t byte)
        {
            if (addr == IO)
                putchar(toupper(byte));
            ((winter*)userdata)->mem[addr] = byte;
        };
    }

    ~winter()
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
                char ch;
                ch = getchar();
                mem[IO] = toupper(ch);
                if (mem[IO] == '\r')
                    mem[IO] = '\n';
                cond.notify();
            }
        }).detach();

        m6502_gen_res(&cpu);
        while (true)
        {
            m6502_step(&cpu);
            if (cpu.wait)
            {
                cond.wait();
                m6502_gen_nmi(&cpu);
            }
        }
    }

public:
    m6502 cpu;
    uint8_t* mem;
    condition cond;
};

int main(int argc, char** argv)
{
    winter w;
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
    w.run();
}
