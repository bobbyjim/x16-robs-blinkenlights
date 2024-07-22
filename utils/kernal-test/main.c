#include <cbm.h>

#include "kernal_test.h"

void setPETFont()
{
   // set PET font
   struct regs fontregs;
   fontregs.a = 4; // PET-like
   fontregs.pc = 0xff62;
   _sys(&fontregs);
}

void main()
{
//   cbm_k_bsout(0x8E); // revert to primary case
//   cbm_k_setnam("petfont.bin");
//   cbm_k_setlfs(0,8,0);
//   cbm_k_load(3, 0x0f000);
   setPETFont();

   testAll();
}
