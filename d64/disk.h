#ifndef _DISK_H_
#define _DISK_H_


typedef struct {

    char label[17];
    char formatName[4];

    unsigned char format; 
    //
    //  64 = D64
    //  65 = LDA
    //  67 = D67
    //  80 = D80
    //  81 = D81
    //  82 = D82
    //

    char dosType[3]; // e.g. "2A"

    int bam_on_hdr            : 1;
    int bam_follows_hdr       : 1;
    int bam_track_before_hdr  : 1;
    
    int double_sided          : 1;
    
    int hdr_dir_track         : 8;
    int hdr_label_offset      : 8;
    int dir_interleave        : 4;
    int file_interleave       : 4;
    int bam_label_offset      : 4;

    int zone1_high            : 8;
    int zone1_spt             : 8;
    int zone2_high            : 8;
    int zone2_spt             : 8;
    int zone3_high            : 8;
    int zone3_spt             : 8;
    int zone4_high            : 8;
    int zone4_spt             : 8;

    int side_2_offset         : 8;

    int bam_interleave        : 4;
    int bam_location          : 8;
    int bam_sectors           : 2;
    int tracks_per_bam_sector : 6;


} Disk;

unsigned char mapImageType(char* filename);
void initImage(char* extension);
void d64_init(Disk *disk); 
void lda_init(Disk *disk); 
void d67_init(Disk *disk); 
void d80_init(Disk *disk); 
void d81_init(Disk *disk); 
void d82_init(Disk *disk); 

long positionAtBlock( int block );
void getLabel(); //Disk *disk);
void disk_details(); //Disk *disk);
void dumpBlock(int block);
void dumpBAM(); //Disk *disk);
void dumpHeader(); 
void dumpDirectory(); //Disk *disk);

#endif
