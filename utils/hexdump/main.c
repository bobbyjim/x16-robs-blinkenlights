#include <peekpoke.h>
#include <cbm.h>
#include <cx16.h>
#include <conio.h>

#include "common.h"
#include "splash.h"

byte* address = 0x0000;
byte color    = COLOR_LIGHTBLUE;

byte colorPalette[4] = { COLOR_PURPLE, COLOR_YELLOW, COLOR_GREEN,	COLOR_GRAY3 };

void hexdump_fast()
{
   register word currentAddress;
   register byte col = 0;
   register char  petscii[17] = "";
   textcolor(color);

   gotoxy(0,3);
   for(currentAddress = 0; currentAddress < 768; ++currentAddress)
   {
      if (col == 16) { // flush
         textcolor(COLOR_GREEN);
         cprintf("%04x %s\r\n", address + currentAddress - 16, petscii);
         textcolor(color);
         col = 0;
      }

      if (col == 0) { // start the row
         textcolor(COLOR_GREEN);
         cprintf("%04x ", address + currentAddress);
         textcolor(color);
      } 
      else if (col == 4 || col == 8 || col == 12) { // spacers
         cputc(' ');
      } 

      cprintf("%02x ", address[currentAddress]);

      if (address[currentAddress] > 31 && address[currentAddress] < 128)
         petscii[col] = address[currentAddress]; 
      else
         petscii[col] = '.';

      ++col;
   }
   textcolor(COLOR_GREEN);
   cprintf("%04x %s", address + currentAddress - 16, petscii);
}

void hexdump_slow() 
{
   register word currentAddress;
   register byte col = 0;
   register char  petscii[17] = "";

   gotoxy(0,3);
   for(currentAddress = 0; currentAddress < 768; ++currentAddress)
   {
      if (col == 16) { // flush
         textcolor(COLOR_GREEN);
         cprintf("%04x %s\r\n", address + currentAddress - 16, petscii);
         textcolor(color);
         col = 0;
      }

      if (col == 0) { // start the row
         textcolor(COLOR_GREEN);
         cprintf("%04x ", address + currentAddress);
         textcolor(color);
      } 
      else if (col == 4 || col == 8 || col == 12) { // spacers
         cputc(' ');
      } 

      if ((address + currentAddress == (byte*)VERSION_ADDR)
	     || address + currentAddress == (byte*)0)
            revers(1);

      if ( address + currentAddress > (byte*)1 
        && address + currentAddress < (byte*)18)
            textcolor(colorPalette[(int)(address+currentAddress-2) % 4]);

      cprintf("%02x ", address[currentAddress]);

      if ( address + currentAddress > (byte*)1 
        && address + currentAddress < (byte*)18)
            textcolor(color);

      if ((address + currentAddress == (byte*)VERSION_ADDR)
	     || address + currentAddress == (byte*)0)
            revers(0);

      if (address[currentAddress] > 31 && address[currentAddress] < 128)
         petscii[col] = address[currentAddress]; 
      else
         petscii[col] = '.';

      ++col;
   }
   textcolor(COLOR_GREEN);
   cprintf("%04x %s", address + currentAddress - 16, petscii);
/*
      for(col=0;col<16;++col)
      {
         reverseAddress = (address + row * 16 + col > 0xfff5)
                       && (address + row * 16 + col < 0xfffa);

         if ( reverseAddress )
            revers(1);

         cputc(petscii[col]);
         if (col == 7)
            cputc(' ');

         if ( reverseAddress )
            revers(0);
      }
   }
   */
}

byte command(char c)
{
   switch(c)
   { 
      case  'q': return 1;                  break;
      case 0x9d: address -= 0x100;          break; // right
      case 0x1d: address += 0x100;          break; // left
      case 0x91: address -= 0x300;          break; // up
      case 0x11: address += 0x300;          break; // down
      case   13: address += 0x1000;         break; // enter
      case   95: address -= 0x1000;         break; // arrow
      case 'a':  ++RAM_BANK;                break; // RAM bank ++
      case 193:  --RAM_BANK;                break; // RAM bank --
      case '1': color = COLOR_WHITE;        break;
      case '2': color = COLOR_LIGHTRED;     break;
      case '3': color = COLOR_CYAN;         break;
      case '4': color = COLOR_PURPLE;       break;
      case '5': color = COLOR_GREEN;        break;
      case '6': color = COLOR_LIGHTBLUE;    break;
      case '7': color = COLOR_YELLOW;       break;
      case '8': color = COLOR_ORANGE;       break;
      case '9': color = COLOR_LIGHTGREEN;   break;
      case '0': color = COLOR_GRAY3;        break;
   }
   return 0;
}

void main(void)
{
   byte quit = 0;

   cbm_k_bsout(0x8E); // revert to primary case
   cbm_k_setnam("petfont.bin");
   cbm_k_setlfs(0,8,0);
   cbm_k_load(3, 0xf000);

   splash();
   common_getVersion();
   common_determineBankCount();
   common_setup();

   while(quit == 0)
   {
      if (kbhit()) {
         quit = command(cgetc());
         hexdump_fast();
       }
      else
         hexdump_fast();
   }
}

