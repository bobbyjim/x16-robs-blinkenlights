;
; Prints an 8 bit value in hex.
;
; Author:               Robert Eaglestone with valuable advice from Steve Wozniak
; More Info:            wozmon.txt
;
; System:               Commander X16
; Version:              Emulator R.37
; Compiler:             CC65
; Build using:  cl65 -t cx16 hex.s -C cx16-asm.cfg -o HEX.PRG
;
chrout		= $ffd2		; Commodore Kernal RULES!

	.org 	$0400
	.export	LOADADDR = *

; $0400
value:		.byte 0		; 0-255

; $0401
Main:		lda value
		pha		; save A for LSD
print_hi:	;
		; print the high nybble
		;
		lsr  		; shift right four bits
		lsr  
		lsr  
		lsr  
		jsr hex

print_lo:	;
		; print the low nybble
		;
		pla		; fetch for LSD
hex:
		and #$0f
		ora #$30	; i.e. "0"
		cmp #$3a	; digit?
		bcc echo	; yes
		adc #6		; add offset for A

echo:
		jsr chrout	; print it
		rts
