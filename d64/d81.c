#include <string.h>
#include "disk.h"

void d81_init(Disk *disk)
{
    strcpy(disk->formatName, "d81");
    disk->format = 81;

    disk->bam_on_hdr            = 1;
    disk->bam_follows_hdr       = 1;
    disk->bam_track_before_hdr  = 2;
    
    disk->double_sided          = 0;
    
    disk->hdr_dir_track         = 0x28;
    disk->hdr_label_offset      = 0x04;
    disk->dir_interleave        = 0x01;
    disk->file_interleave       = 0x01;
    disk->bam_label_offset      = 0x10;

    disk->zone1_high            = 20;
    disk->zone1_spt             = 40;

    disk->zone2_high            = 40;
    disk->zone2_spt             = 40;

    disk->zone3_high            = 60;
    disk->zone3_spt             = 40;

    disk->zone4_high            = 80;
    disk->zone4_spt             = 40;

    disk->bam_interleave        = 1;
    disk->bam_location          = 1;
    disk->bam_sectors           = 2;
    disk->tracks_per_bam_sector = 40;
}
