#include <conio.h>
#include <6502.h>
#include <cbm.h>
#include "platform_cx16.h"

void platform_init(void)
{
    struct regs r;
    cbm_k_bsout(CH_BLACK);
    cbm_k_bsout(0x01);
	textcolor(CH_WHITE);

//    cputc(0x0E);    /* switch to lowercase/mixed-case character mode */
    clrscr();
    r.a  = 4;       /* charset 4 = PET-like font */
    r.x  = 0;
    r.y  = 0;
    r.pc = 0xFF62;  /* KERNAL: screen_set_charset */
    _sys(&r);
}

/*
 * cx16_readline  --  replacement for fgets(buf, len, stdin) on the X16.
 *
 * Uses cgetc() (GETIN/$FFE4) rather than fgets (CHRIN/$FFCF) because
 * cc65's fgets waits for LF ($0A) but the X16 KERNAL delivers CR ($0D)
 * on Enter; this is unreliably translated across ROM versions.
 *
 * Behaviour matches fgets contract:
 *   - reads up to len-2 characters
 *   - appends '\n' then '\0'
 *   - always returns buf (keyboard has no EOF)
 *
 * Also normalises uppercase PETSCII (A-Z, $41-$5A) to lowercase ASCII
 * so command strings match regardless of keyboard mode.
 */
char *cx16_readline(char *buf, int len)
{
    int i = 0;
    int maxlen = len - 2;   /* leave room for '\n' and '\0' */
    unsigned char ch;

    while (i < maxlen) {
        ch = cgetc();

        if (ch == 13) {             /* CR = Enter on X16 */
            cputc(13);              /* carriage return: cursor to col 0 */
            cputc(10);              /* line feed: cursor down one line */
            break;
        }

        if (ch == 20) {             /* PETSCII Delete / backspace */
            if (i > 0) {
                --i;
                cputc(20);          /* CHROUT $14: destructive backspace */
            }
            continue;
        }

        /* normalise PETSCII uppercase A-Z -> lowercase a-z */
        if (ch >= 'A' && ch <= 'Z')
            ch = ch - 'A' + 'a';

        buf[i++] = (char)ch;
        cputc(ch);                  /* echo character */
    }

    buf[i++] = '\n';
    buf[i]   = '\0';
    return buf;
}
