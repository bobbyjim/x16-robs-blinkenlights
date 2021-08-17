
#include <conio.h>

#include "petscii-panel.h"

void panel( unsigned char top, unsigned char left, unsigned char bottom, unsigned char right )
{
   cputcxy(left,top,CORNER_NW);
   cputcxy(right,top,CORNER_NE);
   cputcxy(left,bottom,CORNER_SW);
   cputcxy(right,bottom,CORNER_SE);
   horiz(top,left,right);
   horiz(bottom,left,right);
   vert(left,top,bottom);
   vert(right,top,bottom);
}

void horiz( unsigned char y, unsigned char left, unsigned char right)
{
   while( ++left < right ) cputcxy(left,y,HORIZ);
}

void vert( unsigned char x, unsigned char top, unsigned char bottom)
{
   while( ++top < bottom ) cputcxy(x,top,VERT);
}

void LED( unsigned char color )
{
   textcolor(color);
   cputc(' ');
   cputc(CIRCLE_FILLED);
}

void LED_off()
{
   //textcolor(COLOR_GRAY1);
   cputs("  ");
   //cputc(CIRCLE_FILLED);
}

void LED_bar( unsigned char x, unsigned char y, unsigned char val, unsigned char ledColor, char* label )
{
   gotoxy(x,y);
   textcolor(COLOR_GRAY1);
   cprintf("%02x ", val);
   val & 0x80? LED(ledColor) : LED_off();
   val & 0x40? LED(ledColor) : LED_off();
   val & 0x20? LED(ledColor) : LED_off();
   val & 0x10? LED(ledColor) : LED_off();
   val & 0x08? LED(ledColor) : LED_off();
   val & 0x04? LED(ledColor) : LED_off();
   val & 0x02? LED(ledColor) : LED_off();
   val & 0x01? LED(ledColor) : LED_off();
   textcolor(COLOR_GRAY1);
   cputs("  ");
   if (label) cputs(label);
}

void LED_set( unsigned char num, unsigned char spacing, unsigned char ledColor, unsigned char x, unsigned char y, unsigned char value[], char *label[])
{
    while(num--)
        LED_bar(x, y + num * spacing, value[num], ledColor, label[num]);
}