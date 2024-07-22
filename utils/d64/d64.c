#include <string.h>
#include "disk.h"

void d64_init(Disk *disk)
{    
    strcpy(disk->formatName, "d64");
    disk->format = 64;

    disk->bam_on_hdr            = 1;
    disk->bam_follows_hdr       = 1;
    disk->bam_track_before_hdr  = 2;
    
    disk->double_sided          = 0;
    
    disk->hdr_dir_track         = 0x12;
    disk->hdr_label_offset      = 0x90;
    disk->dir_interleave        = 0x03;
    disk->file_interleave       = 0x0a;
    disk->bam_label_offset      = 0x04;

    disk->zone1_high            = 17;
    disk->zone1_spt             = 21;

    disk->zone2_high            = 24;
    disk->zone2_spt             = 19;

    disk->zone3_high            = 30;
    disk->zone3_spt             = 18;

    disk->zone4_high            = 35;
    disk->zone4_spt             = 17;

    disk->bam_interleave        = 0;
    disk->bam_location          = 0;
    disk->bam_sectors           = 1;
    disk->tracks_per_bam_sector = 35;
}
