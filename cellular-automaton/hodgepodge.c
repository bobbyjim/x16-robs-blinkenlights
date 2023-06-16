
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
#define		FLIP_GRIDS			(activeGrid = 1 - activeGrid)
#define		ACTIVE_GRID(i,j)	grid[activeGrid][i][j]
#define		INACTIVE_GRID(i,j)	grid[1 - activeGrid][i][j]

typedef unsigned char byte;

byte grid[2][ROWS][COLS]; 	// this should be banked
byte activeGrid = 0;

#define 	Strange_G   		13;	/* These values are explained in an issue of */
#define		Strange_k1  		2;	/* Scientific American -- do an electonic    */
#define		Strange_k2  		3;	/* search on "Cellular Automaton".           */

/*---------------------------------

 Lookup Tables for Fast Processing

----------------------------------*/
byte aLookup[256] =			// yes, it looks silly.
{
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
  0
};

byte bLookup[256] =			// looks even sillier.
{
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  1
};

byte colorLookup[16] =
{
	COLOR_BLACK, COLOR_GRAY1, COLOR_BLUE, COLOR_LIGHTBLUE, 
	COLOR_CYAN, COLOR_GREEN, COLOR_LIGHTGREEN, COLOR_YELLOW, 
	COLOR_ORANGE, COLOR_RED, COLOR_PINK, COLOR_PURPLE,
	COLOR_GRAY2, COLOR_GRAY3, COLOR_WHITE
};

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

    gotoxy(0,20);

    cputs("________________________________________________________________________\r\n");
    cputs("    _     _                             ____                            \r\n");
    cputs("    /    /              /               /    )             /            \r\n");
    cputs("---/___ /-----__----__-/----__----__---/____/----__----__-/----__----__-\r\n");
    cputs("  /    /    /   ) /   /   /   ) /___) /        /   ) /   /   /   ) /___)\r\n");
    cputs("_/____/____(___/_(___/___(___/_(___ _/________(___/_(___/___(___/_(___ _\r\n");
    cputs("                            /                                  /        \r\n");
    cputs("                        (_ /                               (_ /         \r\n");
    cputs("_____________________________________________________________________   \r\n");
    cputs("      _                                        _  _     _        ___    \r\n");
    cputs("    /  `                        /              | /     //      /        \r\n");
    cputs("--_/__-----__---)__------_/_---/__----__-------|-------/------/___---   \r\n");
    cputs("  /      /   ) /   )     /    /   ) /___)     /|      /      /    )     \r\n");
    cputs("_/______(___/_/_________(_ __/___/_(___ _____/_|_____/______(____/___   \r\n");
    cputs("                                                                        \r\n");
    cputs("                                                                        \r\n");

    textcolor(COLOR_CYAN);
    cputsxy( 22, 40, "*** PRESS A KEY TO BEGIN ***" );
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

  	revers(1);
}

void hodgepodge() {

	register byte r  = 0, c  = 0;
	register byte A  = 0, B  = 0;
	register byte n  = 0, s  = 0, e  = 0, w  = 0;
	register byte n0 = 0, s0 = 0, e0 = 0, w0 = 0;
	register byte ne = 0, nw = 0, se = 0, sw = 0;
	register byte cur = 0;
	register int check = 0;

	for(;;)
	{
		gotoxy(0,5);
		for(r=0; r<ROWS; ++r)
		   for(c=0; c<COLS; ++c)
		   {
			  textcolor(colorLookup[ACTIVE_GRID(r,c) % 16]);
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

				  B  = bLookup[n0] + bLookup[s0] + bLookup[e0] + bLookup[w0]
				     + bLookup[ne] + bLookup[nw] + bLookup[se] + bLookup[sw];

				  if (cur == 0)
				  {
					INACTIVE_GRID(r,c) = A/Strange_k1 + B/Strange_k2;
				  }
				  else if (A)
				  {
					check = (ne + nw + se + nw + n0 + s0 + e0 + w0)/A;
					check += Strange_G;
					if (check > 255) check = 255;
					INACTIVE_GRID(r,c) = check;
				  }
			  }
		   }

		FLIP_GRIDS;
	}
}
