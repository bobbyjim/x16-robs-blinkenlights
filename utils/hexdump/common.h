#ifndef _COMMON_H_
#define _COMMON_H_

#define VERSION_ADDR	0xff80

#define RVS_ON          18
#define RVS_OFF         146

typedef unsigned int  word;
typedef unsigned char byte;

void common_setup();
void common_determineBankCount();
void common_getVersion();

#endif
