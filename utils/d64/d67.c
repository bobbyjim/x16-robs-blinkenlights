#include <string.h>
#include "disk.h"

void d67_init(Disk *disk)
{
    // 
    //  Shares most of the D64's metadata.
    //
    d64_init(disk);

    strcpy(disk->formatName, "d67");
    disk->format                = 67;  
    disk->file_interleave       = 0x0b; // <--- different from D64 
    disk->zone2_spt             = 20;   // <--- different from D64
}
