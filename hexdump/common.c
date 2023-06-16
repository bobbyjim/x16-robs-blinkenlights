

#include <conio.h>
#include <peekpoke.h>
#include "common.h"

extern word address; // from main.c
extern byte color;   // from main.c

word bankCount;
byte version;
byte modVersion;
char* release;

void common_getVersion()
{
   version = get_ostype();
   if (version > 127)
   {
      release = "proto";
      modVersion = 0x100 - version;
   }
   else
   {
      release = "";
      modVersion = version;
   }
}

void common_determineBankCount()
{
   bankCount = 64;
   RAM_BANK = 255;
   POKE(0xb000,17); 
   if (PEEK(0xb000) == 17) bankCount = 256;

   RAM_BANK = 191;   
   POKE(0xb000,18);  
   if (PEEK(0xb000) == 18) bankCount = 192;
   
   RAM_BANK = 127;
   POKE(0xb000,19);  
   if (PEEK(0xb000) == 19) bankCount = 128;

   RAM_BANK = 0;
}

void common_setup()
{
   gotoxy(1,1);
   cprintf("         ram bank (a): %3u / %3u total                  %s rev %u kernal\r\n", 
      RAM_BANK,
      bankCount,
      release,
      modVersion
   );
   gotoxy(0,3);
   cputs("       0  1  2  3  4  5  6  7    8  9  a  b  c  d  e  f\r\n\r\n");

   textcolor(COLOR_GRAY3);
   cputsxy(15,58,"left/right $100; up/down $300; return/arrow $1000 ");
   textcolor(color);
}
