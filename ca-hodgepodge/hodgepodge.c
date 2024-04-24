#include <cbm.h>
#include <conio.h>
#include <stdlib.h>
/*
██╗  ██╗ ██████╗ ██████╗  ██████╗ ███████╗██████╗  ██████╗ ██████╗  ██████╗ ███████╗
██║  ██║██╔═══██╗██╔══██╗██╔════╝ ██╔════╝██╔══██╗██╔═══██╗██╔══██╗██╔════╝ ██╔════╝
███████║██║   ██║██║  ██║██║  ███╗█████╗  ██████╔╝██║   ██║██║  ██║██║  ███╗█████╗  
██╔══██║██║   ██║██║  ██║██║   ██║██╔══╝  ██╔═══╝ ██║   ██║██║  ██║██║   ██║██╔══╝  
██║  ██║╚██████╔╝██████╔╝╚██████╔╝███████╗██║     ╚██████╔╝██████╔╝╚██████╔╝███████╗
╚═╝  ╚═╝ ╚═════╝ ╚═════╝  ╚═════╝ ╚══════╝╚═╝      ╚═════╝ ╚═════╝  ╚═════╝ ╚══════╝
                                                                                    
███████╗ ██████╗ ██████╗     ████████╗██╗  ██╗███████╗    ██╗  ██╗ ██╗ ██████╗      
██╔════╝██╔═══██╗██╔══██╗    ╚══██╔══╝██║  ██║██╔════╝    ╚██╗██╔╝███║██╔════╝      
█████╗  ██║   ██║██████╔╝       ██║   ███████║█████╗       ╚███╔╝ ╚██║███████╗      
██╔══╝  ██║   ██║██╔══██╗       ██║   ██╔══██║██╔══╝       ██╔██╗  ██║██╔═══██╗     
██║     ╚██████╔╝██║  ██║       ██║   ██║  ██║███████╗    ██╔╝ ██╗ ██║╚██████╔╝     
╚═╝      ╚═════╝ ╚═╝  ╚═╝       ╚═╝   ╚═╝  ╚═╝╚══════╝    ╚═╝  ╚═╝ ╚═╝ ╚═════╝      
                                                                                    

	  Adapted for the Commander X16 from some code I wrote back in 1993.
*/
#define		ROWS				50
#define		COLS				80
#define		FLIP_GRIDS			tempGrid = activeGrid; activeGrid = inactiveGrid; inactiveGrid = tempGrid;
#define		ACTIVE_GRID(i,j)	(*(unsigned char*)(activeGrid + i + j * ROWS))
#define		INACTIVE_GRID(i,j)	(*(unsigned char*)(inactiveGrid + i + j * ROWS))

typedef unsigned char byte;

unsigned activeGrid   = 0x8000; // used to be 1
unsigned inactiveGrid = 0xa000;
unsigned tempGrid = 0x8000;

/* These values are explained in an issue of Scientific American 
   -- do an electonic search on "Cellular Automaton". */

// For Strange_G, try 4 or 13.

#define 	Strange_G   		13
#define		Strange_G_Threshold (255-13)
#define		Strange_k1  		2	
#define		Strange_k2  		3	

/*---------------------------------

 Lookup Tables for Fast Processing

----------------------------------*/
unsigned char *aLookup = ((unsigned char*)0x6000);		
unsigned char *bLookup = ((unsigned char*)0x6100);

/*---------------------------------

	Function Prototypes

 ---------------------------------*/
void init();
void hodgepodge();

/****************************************************************************



				main



****************************************************************************/
void main() {

	init();
	hodgepodge();

}

void init() {

	int i, j;
    clrscr();
                                                                                       
    cputs("8 8888        8     ,o88888o.     8 88888888o.          ,o88888o.    8 8888888   \r\n");
    cputs("8 8888        8  . 888     `88.   8 888    `^888.      888     `88.  8 888       \r\n");
    cputs("8 8888        8 ,8 888       `8b  8 888        `88. ,8 888       `8. 8 888       \r\n");
    cputs("8 8888        8 88 888        `8b 8 888         `88 88 888           8 888       \r\n");
    cputs("8 8888        8 88 888         88 8 888          88 88 888           8 888888888 \r\n");
    cputs("8 8888        8 88 888         88 8 888          88 88 888           8 888       \r\n");
    cputs("8 8888888888888 88 888        ,8P 8 888         ,88 88 888   8888888 8 888       \r\n");
    cputs("8 8888        8 `8 888       ,8P  8 888        ,88' `8 888       .8' 8 888       \r\n");
    cputs("8 8888        8  ` 888     ,88'   8 888    ,o88P'      888     ,88'  8 888       \r\n");
    cputs("8 8888        8     `888888P'     8 88888888P'          `888888P'    8 888888888 \r\n");
    cputs("                                                                                       \r\n");
    cputs("8 888888888o       ,o88888o.     8 88888888o.          ,o88888o.    8 8888888    \r\n");
    cputs("8 8888    `88.  . 888     `88.   8 888    `^888.      888     `88.  8 888        \r\n");
    cputs("8 8888     `88 ,8 888       `8b  8 888        `88. ,8 888       `8. 8 888        \r\n");
    cputs("8 8888     ,88 88 888        `8b 8 888         `88 88 888           8 888        \r\n");
    cputs("8 8888.   ,88' 88 888         88 8 888          88 88 888           8 888888888  \r\n");
    cputs("8 888888888P'  88 888         88 8 888          88 88 888           8 888        \r\n");
    cputs("8 8888         88 888        ,8P 8 888         ,88 88 888   8888888 8 888        \r\n");
    cputs("8 8888         `8 888       ,8P  8 888        ,88' `8 888       .8' 8 888        \r\n");
    cputs("8 8888          ` 888     ,88'   8 888    ,o88P'      888     ,88'  8 888        \r\n");
    cputs("8 8888             `888888P'     8 88888888P'          `888888P'    8 888888888  \r\n");

    textcolor(COLOR_YELLOW);
    cputsxy( 22, 50, "*** PRESS A KEY TO BEGIN ***" );
	while(!kbhit());

    RAM_BANK = 1;
	_randomize();
	bgcolor(COLOR_BLACK);
	clrscr();

	for(i=0; i<ROWS; ++i)
	   for(j=0; j<COLS; ++j)
	   {
	      ACTIVE_GRID(i,j)= rand();
		  INACTIVE_GRID(i,j) = ACTIVE_GRID(i,j);
	   }

    aLookup[255] = 0;
	bLookup[255] = 1;
	for(i=0; i<255; ++i)
	{
		aLookup[i] = 1;
		bLookup[i] = 0;
	}

  	revers(1);
}

void hodgepodge() {

	register byte r  = 0, c  = 0;
	byte A  = 0, B  = 0;
	byte n  = 0, s  = 0, e  = 0, w  = 0;
	byte n0 = 0, s0 = 0, e0 = 0, w0 = 0;
	byte ne = 0, nw = 0, se = 0, sw = 0;
	byte cur = 0;
	int check = 0;

	for(;/*ever*/;)
	{
		gotoxy(0,5);
		for(r=0; r<ROWS; ++r)
		   for(c=0; c<COLS; ++c)
		   {
   		      // draw the current character value
			  textcolor(ACTIVE_GRID(r,c) % 16);
		      cputc(' ');
		   }

		for(r=0; r<ROWS; ++r)
			for(c=0; c<COLS; ++c)
			{
			  // HodgePodge
			  n = r==0? ROWS-1 : r-1;
			  s = r==ROWS-1? 0 : r+1;
			  e = c==COLS-1? 0 : c+1;
			  w = c==0? COLS-1 : c-1;

			  ne = ACTIVE_GRID(n,e);
			  nw = ACTIVE_GRID(n,w);
			  se = ACTIVE_GRID(s,e);
			  sw = ACTIVE_GRID(s,w);
			  n0 = ACTIVE_GRID(n,c);
			  s0 = ACTIVE_GRID(s,c);
			  e0 = ACTIVE_GRID(r,e);
			  w0 = ACTIVE_GRID(r,w);

			  cur = ACTIVE_GRID(r,c);

			  if (cur == 255)
			  {
				INACTIVE_GRID(r,c) = 0;
			  }
			  else
			  {
				  A  = aLookup[n0] + aLookup[s0] + aLookup[e0] + aLookup[w0]
				     + aLookup[ne] + aLookup[nw] + aLookup[se] + aLookup[sw];

				  if (cur == 0)
				  {
				    B  = bLookup[n0] + bLookup[s0] + bLookup[e0] + bLookup[w0]
				       + bLookup[ne] + bLookup[nw] + bLookup[se] + bLookup[sw];

					INACTIVE_GRID(r,c) = (A >> 1) + B/Strange_k2;
				  }
				  else if (A)
				  {
					check = (ne + nw + se + nw + n0 + s0 + e0 + w0)/A; // average value

					if (check >= Strange_G_Threshold)
						check = 255;
					else
						check += Strange_G;

					INACTIVE_GRID(r,c) = check;
				  }
			  }
		   }

		FLIP_GRIDS;
	}
}
