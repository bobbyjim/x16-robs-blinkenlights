
#include <conio.h>
#include <unistd.h>
#include <cx16.h>

unsigned int address[] = {
    0x01d8, 0x01d9, 0x01da, 0x01db, 0x01dc, 0x01dd, 0x01de, 0x01df, 0x01e0, 0x01e1, 0x01e2, 0x01e3, 0x01e4,
    0x9f68, 0x9f69, 
    0x9fb8, 0x9fb9,
    0x9fba, 0x9fbb,
    0x9f64, 0x9f65,
};

//#define     BLOCK_CHAR      208
#define     BLOCK_CHAR      32

void show(unsigned char line, unsigned char position, unsigned char color, unsigned char flag)
{
    revers(1);
    cputcxy(26,line*3,32);
    cputcxy(54,line*3,32);
    cputcxy(26,1+line*3,32);
    cputcxy(54,1+line*3,32);
    cputcxy(26,2+line*3,32);
    cputcxy(54,2+line*3,32);
    revers(0);

    if (flag > 0)
    {
       revers(1);
       textcolor(color);
       gotoxy(29 + position * 3, 0 + line * 3);
       cputc(BLOCK_CHAR);
       cputc(BLOCK_CHAR);
       gotoxy(29 + position * 3, 1 + line * 3);
       cputc(BLOCK_CHAR);
       cputc(BLOCK_CHAR);
       revers(0);
       textcolor(COLOR_GRAY1);
    }
    else
    {
       cputsxy(29 + position * 3, 0 + line * 3, "  ");
       cputsxy(29 + position * 3, 1 + line * 3, "  ");
       cputc(' ');
    }
    
}

unsigned char color[20] = {
    COLOR_RED,
    COLOR_RED,
    COLOR_RED,
    COLOR_RED,
    COLOR_GREEN,
    COLOR_GREEN,
    COLOR_GREEN,
    COLOR_GREEN,
    COLOR_YELLOW,
    COLOR_YELLOW,
    COLOR_YELLOW,
    COLOR_YELLOW,
    COLOR_BLUE,
    COLOR_BLUE,
    COLOR_BLUE,
    COLOR_BLUE,
    COLOR_ORANGE,
    COLOR_ORANGE,
    COLOR_ORANGE,
    COLOR_ORANGE,
};
void draw()
{
    int loc;
    unsigned char val;

    //gotoxy(0,1);
    for(loc=0; loc<20; ++loc)
    {
        val = ((*(unsigned char *)address[loc]));
        //gotoxy(20, loc * 3);
        //cprintf("%04x", address[loc]);
        show(loc, 0, color[loc], val & 1);
        show(loc, 1, color[loc], val & 2);
        show(loc, 2, color[loc], val & 4);
        show(loc, 3, color[loc], val & 8);
        show(loc, 4, color[loc], val & 16);
        show(loc, 5, color[loc], val & 32);
        show(loc, 6, color[loc], val & 64);
        show(loc, 7, color[loc], val & 128); 
        gotoxy(56,loc * 3);
        cprintf("%02x %04x", val, address[loc]);
    }
}

void main(void)
{
    cbm_k_bsout(0x8E); // revert to primary case
    bgcolor(COLOR_BLACK);
    clrscr();
    for(;;)
    {
        draw();
        sleep(1);
    }
}