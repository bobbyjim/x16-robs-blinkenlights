#ifndef _KERNAL_TEST_H
#define _KERNAL_TEST_H

#include <6502.h>

#define     KERNAL_CHROUT       0xffd2
#define     KERNAL_MEMTOP       0xff99
#define     KERNAL_MEMBOT       0xff9c
#define     KERNAL_RESTOR       0xff8a
#define     KERNAL_SETTIM       0xffdb
#define     KERNAL_RDTIM        0xffde
#define     KERNAL_UDTIM        0xffea

void setregs(
        unsigned char a,
        unsigned char x,
        unsigned char y,
        unsigned char flags,
        unsigned pc);

void testAll();

void doit();
unsigned char showResult(char *label, unsigned char res);
unsigned char accumulator();
unsigned char x_register();
unsigned char y_register();
unsigned char accumulator_is(int v);
unsigned char x_register_is(int v);
unsigned char y_register_is(int v);
unsigned pc();

unsigned char kernal_test_chrout(char c);
unsigned char kernal_test_memtop_read();
unsigned char kernal_test_memtop_write();
unsigned char kernal_test_membot_read();
unsigned char kernal_test_membot_write();
unsigned char kernal_test_setnam_setlfs_load();
unsigned char kernal_test_iobase();

unsigned char kernal_test_settim();
unsigned char kernal_test_rdtim();
unsigned char kernal_test_settim_and_udtim_and_rdtim();

#endif
