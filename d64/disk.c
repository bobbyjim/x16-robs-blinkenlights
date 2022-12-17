#include <stdio.h>
#include <string.h>
#include <cx16.h>
#include <ctype.h>
#include <conio.h>

#include "disk.h"

Disk disk;

unsigned char mapImageType(char* filename)
{
   int len = strlen(filename);
   if (len < 4) return 0;

   switch(filename[len-1])
   {
       case '0': // D80
          return 80;

       case '1': // D81
          return 81;

       case '2': // D82
          return 82;

       case '4': // D64
          return 64;

       case '7': // D67
          return 67;

       case 'A': // LDA
          return 65;
   }
   return 0;
}

void initImage(char* extension)
{
   switch(mapImageType(extension))
   {
        default:
        case 64: d64_init(&disk); break;
        case 65: lda_init(&disk); break;
        case 67: d67_init(&disk); break;
        case 80: d80_init(&disk); break;
        case 81: d81_init(&disk); break;
        case 82: d82_init(&disk); break;
   }
   getLabel();
}

int calculateBlock(Disk *disk, int track)
{
    int block_offset;

    --track; // adjust to "offset track"

    // track 1 always starts at block 0.   
    if ( track <= disk->zone1_high) // is track in zone 1?
       return track * disk->zone1_spt;

    // skip zone 1 tracks.
    block_offset = disk->zone1_high * disk->zone1_spt;

    if (track <= disk->zone2_high) // is track in zone 2?
       return block_offset
            + (track - disk->zone1_high) * disk->zone2_spt;

    // skip zone 2 tracks.
    block_offset += (disk->zone2_high - disk->zone1_high) * disk->zone2_spt;

    if (track <= disk->zone3_high) // is track in zone 3?
       return block_offset
            + (track - disk->zone2_high) * disk->zone3_spt;

    // skip zone 3 tracks.
    block_offset += (disk->zone3_high - disk->zone2_high) * disk->zone3_spt;

    // assume it's in zone 4
    return block_offset
         + (track - disk->zone3_high) * disk->zone4_spt;
}

/*int calculateHeaderBlock(Disk *disk)
{
    return calculateBlock( disk, disk->hdr_dir_track );
}*/

void disk_details() //Disk *disk)
{
    int dirBlock = calculateBlock(&disk, disk.hdr_dir_track);
    
    printf("        label : \"%16s\"\n", disk.label);
    printf("       format : %3s\n", disk.formatName);
    printf("          dos : %2s\n", disk.dosType);
    printf("    dir track : %d\n", disk.hdr_dir_track);
    printf("        block : %d\n", dirBlock);
    printf("\n\n");
}

void dumpTracks()
{
    int i;
    printf("track offsets:\n");
    for(i=1; i<=35; ++i)
       printf("   - %d/0: %d\n", i, calculateBlock(&disk, i));
}

//
//  returns the intra-bank offset for the block
//
long positionAtBlock( int block )
{
    long diskpos = 256l * block;

    RAM_BANK = (block / 32) + 1;
    block %= 32;
    
    return -2 + 256l * block;
}

void getLabel()
{
    long localpos = positionAtBlock( calculateBlock( &disk, disk.hdr_dir_track ) );

    printf(" label offset = %d\n", 0xa000 + localpos + disk.hdr_label_offset);

    strncpy(disk.label, (char*)BANK_RAM[ 0xa000 + localpos + disk.hdr_label_offset], 16);
    strncpy(disk.dosType, (char*)BANK_RAM[ 0xa000 + localpos + disk.hdr_label_offset + 17], 3);
}

void dumpBlock( int block )
{
    int i;
    int c;
    long diskpos = 256l * block;
    long localpos = positionAtBlock( block );
    char line[17];

    clrscr();
    gotoxy(0,2);

    //printf(" bank        : %d\n", RAM_BANK);
    printf(" disk pos    : $%lx / %ld\n", diskpos, diskpos);
    //printf(" bank offset : $%x\n",  block * 256);
    //printf(" local pos   : $%lx\n", localpos);
    printf("\n");

    for(i=0; i<256 * 3; ++i)
    {
       if (i % 16 == 0) 
           printf("\n %04lx : ", diskpos + i);

       c = BANK_RAM[ localpos + i ];

       if (c == 0)
          printf("  .");
       else if (c == 255)
          printf("  -");
       else 
          printf(" %02x", c);

       if (i % 16 == 7) printf(" ");

       if (i % 16 == 15)
       {
           printf( "   %s", line );
       }
       else
       {
           line[i % 16] = isalnum(c)? c : '.';
       }
       if (i % 256 == 255 ) printf("\n");
    }
    printf("\n");
}

void dumpBAM()
{
}

void dumpHeader()
{
    clrscr();
    gotoxy(0, 1);
    printf("%s %s\n", disk.label, disk.dosType);
}

void dumpDirectory()
{
}
