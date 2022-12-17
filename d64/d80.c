#include <string.h>
#include "disk.h"

void d80_init(Disk *disk)
{
    strcpy(disk->formatName, "d80");
    disk->format = 80;

    disk->bam_on_hdr            = 0;
    disk->bam_follows_hdr       = 1;
    disk->bam_track_before_hdr  = 2;
    
    disk->double_sided          = 0;
    
    disk->hdr_dir_track         = 0x27;
    disk->hdr_label_offset      = 0x06;
    disk->dir_interleave        = 0x01;
    disk->file_interleave       = 0x01;
    disk->bam_label_offset      = 0x06;

    disk->zone1_high            = 39;
    disk->zone1_spt             = 29;

    disk->zone2_high            = 53;
    disk->zone2_spt             = 27;

    disk->zone3_high            = 64;
    disk->zone3_spt             = 25;

    disk->zone4_high            = 77;
    disk->zone4_spt             = 23;

    disk->bam_interleave        = 0x03;
    disk->bam_location          = 0x02;
    disk->bam_sectors           = 0x02;
    disk->tracks_per_bam_sector = 50;
}
