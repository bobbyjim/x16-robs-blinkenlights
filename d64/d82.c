#include <string.h>
#include "disk.h"

void d82_init(Disk *disk)
{
    d80_init(disk);

    strcpy(disk->formatName, "d82");
    disk->format                = 82;    
    disk->double_sided          = 1;
    disk->side_2_offset         = 77;
    disk->bam_sectors           = 0x04;
}
