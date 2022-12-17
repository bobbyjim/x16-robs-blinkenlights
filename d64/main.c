#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <cbm.h>
#include <cx16.h>
#include <conio.h>

#include "disk.h"

#define LOAD_TO_MAIN_RAM      0
#define LOAD_TO_VERA          2
#define PROMPT                cprintf("\r\n%u %c ", _heapmemavail(), '%')

void load(char *image)
{
   RAM_BANK = 1;
   cbm_k_setnam(image);
   cbm_k_setlfs(0,8,0);
   cbm_k_load(LOAD_TO_MAIN_RAM, 0xa000);
}

unsigned char i;
char lineInputBuffer[80];
char filename[80];

int readLine()
{
   PROMPT;
   if (!fgets(lineInputBuffer, sizeof(lineInputBuffer), stdin))
   {
      printf("\n");
      return 0;
   }
   lineInputBuffer[strlen(lineInputBuffer)-1] = '\0'; // chop newline
   return 1;
}

int block = 0;

void main()
{
   cbm_k_bsout(0x8E); // revert to primary case

   cbm_k_setnam("petfont.bin");
   cbm_k_setlfs(0,8,0);
   cbm_k_load(LOAD_TO_VERA, 0x0f800);

   printf( "d64 shell\n\n" );
   printf( "%cdemo.d64 to load demo.d64\n", 95 );
   printf( "b 357 to view block 357\n" );
   printf( "d64, d67, d80, d81, and d82 supported\n" );

   while(readLine())
   {
      if (lineInputBuffer[0] == 95)
      {
         if (mapImageType(lineInputBuffer+1) > 0)
         {
            clrscr();
            printf("file: \"%s\"\n\n", lineInputBuffer+1);
            load(lineInputBuffer+1);
            initImage(lineInputBuffer+1);
            disk_details();
         }
      }
      else if (sscanf(lineInputBuffer, "b %d", &block) == 1)
      {
         dumpBlock(block);
      }
      else if (lineInputBuffer[0] == 'h')
      { 
         dumpHeader();
      }
      else if (lineInputBuffer[0] == 'd')
      {
         dumpDirectory();
      }
   }
   //load("demo.d64");     // 22 banks 
   //initImage("d64");
   //dumpHeader();
   
   //load("my67test.d67"); // 22 banks 
   //load("my80test.d80"); // 66 banks
   //load("trader64.d81"); // 100 banks
   //load("my82test.d82"); // 108 banks
   //load("test2.lda");
   //load("lda3test.lda");


}