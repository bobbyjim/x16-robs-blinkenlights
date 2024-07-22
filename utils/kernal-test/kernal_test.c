#include <conio.h>
#include <cx16.h>

#include "kernal_test.h"

struct regs testregs;

int err = 0;
int sum = 0;

void banner()
{
   textcolor( COLOR_ORANGE );
   cputs("        --------------------------------------------------------------\r\n");
   cputs("        '##:::'##:'########:'########::'##::: ##::::'###::::'##:::::::\r\n");
   cputs("         ##::'##:: ##.....:: ##.... ##: ###:: ##:::'## ##::: ##:::::::\r\n");
   cputs("         ##:'##::: ##::::::: ##:::: ##: ####: ##::'##:. ##:: ##:::::::\r\n");
   cputs("         #####:::: ######::: ########:: ## ## ##:'##:::. ##: ##:::::::\r\n");
   cputs("         ##. ##::: ##...:::: ##.. ##::: ##. ####: #########: ##:::::::\r\n");
   cputs("         ##:. ##:: ##::::::: ##::. ##:: ##:. ###: ##.... ##: ##:::::::\r\n");
   cputs("         ##::. ##: ########: ##:::. ##: ##::. ##: ##:::: ##: ########:\r\n");
   cputs("        ..::::..::........::..:::::..::..::::..::..:::::..::........::\r\n");
   cputs("        ::::::::::'########:'########::'######::'########:::::::::::::\r\n");
   cputs("        ::::::::::... ##..:: ##.....::'##... ##:... ##..::::::::::::::\r\n");
   cputs("        ::::::::::::: ##:::: ##::::::: ##:::..::::: ##::::::::::::::::\r\n");
   cputs("        ::::::::::::: ##:::: ######:::. ######::::: ##::::::::::::::::\r\n");
   cputs("        ::::::::::::: ##:::: ##...:::::..... ##:::: ##::::::::::::::::\r\n");
   cputs("        ::::::::::::: ##:::: ##:::::::'##::: ##:::: ##::::::::::::::::\r\n");
   cputs("        ::::::::::::: ##:::: ########:. ######::::: ##::::::::::::::::\r\n");
   cputs("        --------------------------------------------------------------\r\n\r\n");
}

void testAll()
{
    int x;

    bgcolor( COLOR_BLACK );
    clrscr();
    banner();

    textcolor( COLOR_LIGHTBLUE );
    cprintf("  if this is in a \"pet\" font, then load to vera works!\r\n\r\n");
    cprintf(" %20s : %s     %2s   %2s   %2s  %4s  %s \r\n ", 
        "test name",
        "rslt",
        "a",
        "x",
        "y",
        "flags",
        "pc" );

   for(x=2; x<80; ++x) cputc(192);      
   cputs("        \r\n");

   sum += showResult("chrout",              kernal_test_chrout('a'));
   sum += showResult("memtop/r",            kernal_test_memtop_read());
   sum += showResult("memtop/w",            kernal_test_memtop_write());
   sum += showResult("membot/r",            kernal_test_membot_read());
   sum += showResult("membot/w",            kernal_test_membot_write());
   sum += showResult("setnam setlfs load",  kernal_test_setnam_setlfs_load());
   sum += showResult("iobase",              kernal_test_iobase());
//   sum += showResult("settim",              kernal_test_settim());
//   sum += showResult("rdtim",               kernal_test_rdtim());
   sum += showResult("set/ud/rdtim",        kernal_test_settim_and_udtim_and_rdtim());

   textcolor( err == 0 ? COLOR_GREEN : COLOR_LIGHTRED );
   cprintf("\r\n %16s : %d\r\n\r\n", "errors", err);
   cputs("done!\r\n");
}

void setregs(
        unsigned char a,
        unsigned char x,
        unsigned char y,
        unsigned char flags,
        unsigned pc)
{
    testregs.a = a;
    testregs.x = x;
    testregs.y = y;
    testregs.flags = flags;
    testregs.pc = pc;
}

void doit()
{
    _sys(&testregs);
}

unsigned char showResult(char *label, unsigned char res)
{
    cprintf(" %20s : %4s     %2x   %2x   %2x   %2x   %x \r\n", 
        label, 
        res == 0? "ok" : "fail",
        testregs.a,
        testregs.x,
        testregs.y,
        testregs.flags,
        testregs.pc );

    return res;
}

unsigned char accumulator()
{
    return testregs.a;
}

unsigned char x_register()
{
    return testregs.x;
}

unsigned char y_register()
{
    return testregs.y;
}

unsigned pc()
{
    return testregs.pc;
}

unsigned char accumulator_is(int v)
{
    return testregs.a == v;
}

unsigned char x_register_is(int v)
{
    return testregs.x == v;
}

unsigned char y_register_is(int v)
{
    return testregs.y == v;
}
