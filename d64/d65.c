#include <string.h>
#include "disk.h"
//
//  LDA images have an initial 512 byte header.
//  They have no BAM.
//  They have a variable number of blocks.
//
void lda_init(Disk *disk)
{
    strcpy(disk->formatName, "lda");
    disk->format = 65;

    disk->bam_on_hdr            = 1;
    disk->bam_follows_hdr       = 1;
    disk->bam_track_before_hdr  = 2;
    
    disk->double_sided          = 0;
    
    disk->hdr_dir_track         = 0x00;
    disk->hdr_label_offset      = 0x04;
    disk->dir_interleave        = 0x01;
    disk->file_interleave       = 0x01;
    disk->bam_label_offset      = 0x00;

    disk->zone1_high            = 0;
    disk->zone1_spt             = 0;
    disk->zone2_high            = 0;
    disk->zone2_spt             = 0;
    disk->zone3_high            = 0;
    disk->zone3_spt             = 0;
    disk->zone4_high            = 0;
    disk->zone4_spt             = 0;

    disk->bam_interleave        = 0;
    disk->bam_location          = 0;
    disk->bam_sectors           = 0;
    disk->tracks_per_bam_sector = 0;
}
