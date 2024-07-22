#include <conio.h>
#include <unistd.h>
#include "splash.h"
#include "common.h"

void splash() {
   textcolor(COLOR_GREEN);
   bgcolor(COLOR_BLACK);
   clrscr();
   gotoxy(0,14);

   cputs("         hhhhhhh                                                        \r\n");
   cputs("         h:::::h                                                        \r\n");
   cputs("         h:::::h                                                        \r\n");
   cputs("         h:::::h                                                        \r\n");
   cputs("          h::::h hhhhh           eeeeeeeeeeee  xxxxxxx      xxxxxxx     \r\n");
   cputs("          h::::hh:::::hhh      ee::::::::::::ee x:::::x    x:::::x      \r\n");
   cputs("          h::::::::::::::hh   e::::::eeeee:::::eex:::::x  x:::::x       \r\n");
   cputs("          h:::::::hhh::::::h e::::::e     e:::::e x:::::xx:::::x        \r\n");
   cputs("          h::::::h   h::::::he:::::::eeeee::::::e  x::::::::::x         \r\n");
   cputs("          h:::::h     h:::::he:::::::::::::::::e    x::::::::x          \r\n");
   cputs("          h:::::h     h:::::he::::::eeeeeeeeeee     x::::::::x          \r\n");
   cputs("          h:::::h     h:::::he:::::::e             x::::::::::x         \r\n");
   cputs("          h:::::h     h:::::he::::::::e           x:::::xx:::::x        \r\n");
   cputs("          h:::::h     h:::::h e::::::::eeeeeeee  x:::::x  x:::::x       \r\n");
   cputs("          h:::::h     h:::::h  ee:::::::::::::e x:::::x    x:::::x      \r\n");
   cputs("         vvvvvvvh     hhhhhvvvvvvvuuuuuueeeeuuuuuuxxxx  eeeeeeeeeeee    \r\n");
   cputs("          v:::::v         v:::::v u::::u    u::::u    ee::::::::::::ee  \r\n");
   cputs("           v:::::v       v:::::v  u::::u    u::::u   e::::::eeeee:::::ee\r\n");
   cputs("            v:::::v     v:::::v   u::::u    u::::u  e::::::e     e:::::e\r\n");
   cputs("             v:::::v   v:::::v    u::::u    u::::u  e:::::::eeeee::::::e\r\n");
   cputs("              v:::::v v:::::v     u::::u    u::::u  e:::::::::::::::::e \r\n");
   cputs("               v:::::v:::::v      u::::u    u::::u  e::::::eeeeeeeeeee  \r\n");
   cputs("                v:::::::::v       u:::::uuuu:::::u  e:::::::e           \r\n");
   cputs("                 v:::::::v        u:::::::::::::::uue::::::::e          \r\n");
   cputs("                  v:::::v          u:::::::::::::::u e::::::::eeeeeeee  \r\n");
   cputs("                   v:::v            uu::::::::uu:::u  ee:::::::::::::e  \r\n");
   cputs("                    vvv               uuuuuuuu  uuuu    eeeeeeeeeeeeee  \r\n");

   sleep(1);
}
