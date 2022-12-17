
#include <peekpoke.h>
#include <6502.h>
#include <cbm.h>

#define BANNER_LOAD_ADDR        0x400
#define BANNER_EXEC             0x401

void splashInit()
{
   cbm_k_setnam("banner-font-0400.bin");
   cbm_k_setlfs(0,8,0);
   cbm_k_load(0, 0x0400);
}

void splashBanner(char* string)
{
   struct regs r;
   r.a = 0;
   r.x = 0;
   r.y = 0;
   r.flags = 0;
   r.pc = BANNER_EXEC;

   while(*string)
   {
      POKE(BANNER_LOAD_ADDR, *string);
      _sys(&r);
      ++string;
   }
}
