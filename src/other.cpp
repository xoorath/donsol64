#include <stdio.h>
#include <malloc.h>
#include <string.h>
#include <stdint.h>
#include <libdragon.h>
#include <libed64.h>

#include "./test.h"

void vblCallback(void) __attribute__((section(".text.after")));
void vblCallback(void) {}


static resolution_t res = RESOLUTION_320x240;
static bitdepth_t bit = DEPTH_32_BPP;

class TestClass
{
    private:
        int d;

    public:
        TestClass() {
            d = 2;
        }
        int f1()
        {
            return d;
        }
};

int main(void)
{
    TestClass o1;
    TestClass *o2 = &o1;//new TestClass();

    init_interrupts();

    //display_close();
    display_init( res, bit, 2, GAMMA_NONE, ANTIALIAS_RESAMPLE );

    everdrive_init(true);
    register_VI_handler(vblCallback);

    while(1)
    {
        console_clear();
        printf("Libdragon v%d.%d.%d", libdragon_version.major, libdragon_version.minor, libdragon_version.revision);
        printf("Test: %d", o1.f1());
        printf("Test2: %d", o2->f1());
        console_render();
        testfoo::foo();
        handle_everdrive();
    }

    delete o2;
}
