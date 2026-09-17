#ifndef PLATFORM_CX16_H
#define PLATFORM_CX16_H

/* Commander X16 / cc65 platform. */
#include <stdlib.h>   /* _randomize */
#include <conio.h>    /* cprintf, cputc, cgetc */

#define time(X)        (0)
#define srand(X)       _randomize()

#define MAIN           void main

/* Switch to lowercase mode, clear screen. */
void platform_init(void);

/*
 * cx16_readline replaces fgets(buf, len, stdin).
 * Declare before the macro so the declaration itself is not substituted.
 */
char *cx16_readline(char *buf, int len);
#define fgets(buf, len, stream)  cx16_readline(buf, len)

/* Switch to lowercase mode, clear screen. */
void platform_init(void);

/*
 * cx16_readline replaces fgets(buf, len, stdin).
 * fgets/CHRIN hangs on the X16 because cc65 fgets waits for LF ($0A)
 * but the KERNAL delivers CR ($0D) on Enter — unreliably translated
 * across ROM versions.  This implementation uses cgetc() (GETIN)
 * and handles CR directly.
 *
 * Declare before the macro so the declaration itself is not substituted.
 */
char *cx16_readline(char *buf, int len);
#define fgets(buf, len, stream)  cx16_readline(buf, len)

#endif
