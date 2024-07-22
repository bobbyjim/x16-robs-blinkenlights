# x16-banner
An assembly language routine which prints "banner" text using PETSCII.

# How to Use
* This code is currently compiled to banked RAM at address $A000.
* Load the PRG file into memory at $A000.
* Poke the desired PETSCII character code into $A000.
* Call the routine at $A001.

e.g.
```
LOAD"BANNER-FONT.PRG",8,1,$A000
POKE $A000, 65 :REM "A"
SYS $A001
```
# Supported Characters
Version 1 only supports A-Z and space. The characters are 3 x 3 characters in size, with a special "space" character that is 2 characters wide.

# How to Compile
This is the command I use to compile the source:

```cl65 -o BANNER-FONT.PRG -t cx16 -C cx16-asm.cfg banner.s```
