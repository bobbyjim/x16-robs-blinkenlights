#include <conio.h>
#include <6502.h>

#include "kernal_test.h"

#define     FREE_RAM        ((unsigned char *) 0x400)

//
//  tests setnam, setlfs, and load
//
unsigned char kernal_test_setnam_setlfs_load()
{
   cbm_k_setnam("test1.bin");
   cbm_k_setlfs(0,8,0);
   cbm_k_load(0, 0x400);
   //
   // now let's see if it really loaded the file into 0x400.
   //
   return FREE_RAM[0] != 1 || FREE_RAM[1] != 2 || FREE_RAM[2] != 3 || FREE_RAM[3] != 4;
}
