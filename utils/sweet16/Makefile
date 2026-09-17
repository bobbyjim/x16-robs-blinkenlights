# Makefile for SWEET16 and test harness

CC65 = cl65
X16EMU = ../../../x16
AFLAGS = -t cx16 -C cx16-asm.cfg

# Default target: build both
all: SWEETX16.PRG SWEETX16TEST.PRG

# Build SWEET16 interpreter at 0x0600
SWEETX16.PRG: sweetX16.s
	$(CC65) --start-addr 0x0600 $(AFLAGS) sweetX16.s -o SWEETX16.PRG

# Build test harness
SWEETX16TEST.PRG: sweetX16_test.s
	$(CC65) --start-addr 0x0801 $(AFLAGS) sweetX16_test.s -o SWEETX16TEST.PRG

# Run tests in emulator
test: SWEETX16.PRG SWEETX16TEST.PRG
	$(X16EMU) -prg SWEETX16.PRG -prg SWEETX16TEST.PRG -run

# Clean build artifacts
clean:
	rm -f *.PRG *.o

.PHONY: all test clean
