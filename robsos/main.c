/*
    ROBSOS

    Copyright (C) 2022 Robert Eaglestone

    This file is part of ROBSOS

    ROBSOS is free software: you can redistribute it and/or modify
    it under the terms of the MIT License.

    ROBSOS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    MIT License for more details.

    You should have received a copy of the MIT License along with ROBSOS.  
    If not, see <https://mit-license.org/>.
*/
#include <conio.h>
#include <stdio.h>

#include "common.h"
#include "trk.h"
#include "ci.h"

void r39test()
{
   char cc;

   cputs("this is a test\r\n");
   cputc('x');
   puts("press enter\n");
   cc = cgetc();
}

void main() 
{
   r39test();
   
   bgcolor(COLOR_BLACK);
   textcolor(COLOR_GRAY3);
   clrscr();

   common_loadFile("trkmem.bin", 1);
   common_loadFile("volumes.bin", 2);
   common_loadFileAt("trap.txt", 3, 0xa000);
   common_loadFileAt("swer.txt", 3, 0xa400);
  
   trk_initTrunks();
   ci_login();

   for(;;)
   {
      ci_run();
      ci_readLine();
   }
}

