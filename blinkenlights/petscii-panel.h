#ifndef _PETSCII_PANEL_H_
#define _PETSCII_PANEL_H_

#define CORNER_NW       213
#define CORNER_NE       201
#define CORNER_SW       202
#define CORNER_SE       203
#define VERT            221
#define HORIZ           192

#define CIRCLE_FILLED   113
#define CIRCLE_OPEN     119
#define LED_OFF         COLOR_BLACK
// #define LED_OFF  COLOR_GRAY1

void panel( unsigned char top, unsigned char left, unsigned char bottom, unsigned char right );
void horiz( unsigned char y, unsigned char left, unsigned char right);
void vert( unsigned char x, unsigned char top, unsigned char bottom);
void LED_bar( unsigned char x, unsigned char y, unsigned char value, unsigned char ledColor, char* label );
void LED_set( unsigned char num, unsigned char spacing, unsigned char ledColor, unsigned char x, unsigned char y, unsigned char value[], char *label[]);

#endif