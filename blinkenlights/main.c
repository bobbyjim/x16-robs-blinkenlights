
#include <conio.h>
#include <unistd.h>
#include <cx16.h>
#include <time.h>
#include <stdlib.h>
#include <joystick.h>

#include "petscii-panel.h"

#define TIMEPANEL_TOP           6
#define TIMEPANEL_LEFT          8
#define TIMEPANEL_BOTTOM        TIMEPANEL_TOP  + 12
#define TIMEPANEL_RIGHT         TIMEPANEL_LEFT + 27

#define IOPANEL_TOP             26
#define IOPANEL_LEFT            8
#define IOPANEL_BOTTOM          IOPANEL_TOP + 28
#define IOPANEL_RIGHT           IOPANEL_LEFT + 27

#define STACKPANEL_TOP          6
#define STACKPANEL_LEFT         45
#define STACKPANEL_BOTTOM       STACKPANEL_TOP  + 32
#define STACKPANEL_RIGHT        STACKPANEL_LEFT + 27

#define KERNAL_TOP              46
#define KERNAL_LEFT             45
#define KERNAL_BOTTOM           KERNAL_TOP + 8
#define KERNAL_RIGHT            KERNAL_LEFT + 27

char* labels_stack[] = {
    "01d5", "01d6", "01d7", "01d8", "01d9", "01da", "01db", "01dc", "01dd", "01de", "01df", 
    "01e0", "01e1", "01e2", "01e3", "01e4", "01e5", "01e6",

};

unsigned int address_stack[] = {
    0x01d5, 0x01d6, 0x01d7, 0x01d8, 0x01d9, 0x01da, 0x01db, 0x01dc, 0x01dd, 0x01de, 0x01df, 
    0x01e0, 0x01e1, 0x01e2, 0x01e3, 0x01e4, 0x01e5, 0x01e6,
};

char* labels_io[] = {
    "9f64", "9f65",
    "9f66", "9f67",
    "9f68", "9f69", 
    "9fb8", "9fb9",
    "9fba", "9fbb",
};

unsigned int address_io[] = {
    0x9f64, 0x9f65,
    0x9f66, 0x9f67,
    0x9f68, 0x9f69, 
    0x9fb8, 0x9fb9,
    0x9fba, 0x9fbb,
};

char* labels_tm[] = { "tm_yr", "tm_mo", "tm_da", "tm_hr", "tm_mi", "tm_sc" };

time_t tp;
struct tm *ltime;
struct tm timep;
struct timespec ts;

/*
   timep.tm_year = 121;
   timep.tm_mon  = 7;    // 0-11
   timep.tm_mday = 17;   // 1-31 ***
   timep.tm_hour = 13;   // 0-23
   timep.tm_min  = 23;   // 0-59
   timep.tm_sec  = 0;    // 0-59

   ts.tv_sec  = mktime(&timep);
   ts.tv_nsec = 0L;
   clock_settime(CLOCK_REALTIME, &ts);
*/

unsigned char delay = 0;

void timePanel()
{
   unsigned char elems[6];
   time(&tp);
   ltime = localtime(&tp);
   
   elems[0] = (unsigned char) ltime->tm_year;
   elems[1] = (unsigned char) ltime->tm_mon+1;
   elems[2] = (unsigned char) ltime->tm_mday;
   elems[3] = (unsigned char) ltime->tm_hour;
   elems[4] = (unsigned char) ltime->tm_min;
   elems[5] = (unsigned char) ltime->tm_sec;
   
   LED_set(6, 2, COLOR_ORANGE, TIMEPANEL_LEFT, TIMEPANEL_TOP, elems, labels_tm);
}

void ioPanel()
{
    unsigned char elems[10];
    unsigned char x;

    for(x=0; x<10; ++x)
        elems[x] = *(unsigned char *) address_io[x];

    LED_set(10, 3, COLOR_BLUE, IOPANEL_LEFT, IOPANEL_TOP, elems, labels_io);
}

void stackPanel()
{
    unsigned char x;
    unsigned char elems[16];

    for(x=0; x<16; ++x)
        elems[x] = *(unsigned char *) address_stack[x];

    LED_set(16, 2, COLOR_RED, STACKPANEL_LEFT, STACKPANEL_TOP, elems, labels_stack);
}

void keyboard()
{   
   if (kbhit())
   {
      LED_bar( KERNAL_LEFT, KERNAL_TOP, cgetc(), COLOR_GREEN, "kbd" );
      delay = 3;
      _randomize();
   }
   else 
   {
       if (delay > 0) 
          --delay;
       else
          LED_bar( KERNAL_LEFT, KERNAL_TOP, 0, COLOR_GREEN, "kbd" );
   }
}

void status()
{
    LED_bar( KERNAL_LEFT, KERNAL_TOP + 2, cbm_k_readst(), COLOR_YELLOW, "st" );
}

void main(void)
{  
   cbm_k_bsout(0x8E); // revert to primary case

   cbm_k_setnam("petfont.bin");
   cbm_k_setlfs(0,8,0);
   cbm_k_load(2, 0x0f800);

   bgcolor(COLOR_BLACK);
   clrscr();

   textcolor(COLOR_GRAY1);
   panel(STACKPANEL_TOP-4,STACKPANEL_LEFT-4,STACKPANEL_BOTTOM+2,STACKPANEL_RIGHT+2);
   panel(TIMEPANEL_TOP-4,TIMEPANEL_LEFT-4,TIMEPANEL_BOTTOM+2,TIMEPANEL_RIGHT+2);
   panel(IOPANEL_TOP-4, IOPANEL_LEFT-4, IOPANEL_BOTTOM+2, IOPANEL_RIGHT+2);
   panel(KERNAL_TOP-4, KERNAL_LEFT-4, KERNAL_BOTTOM+2, KERNAL_RIGHT+2);

   _randomize();

   for(;;)
   { 
      timePanel();
      ioPanel();
      stackPanel();
      keyboard();
      status();

      sleep(1);
   }
}