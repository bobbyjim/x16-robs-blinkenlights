;
; cl65 -o MEMORY.PRG -t cx16 -C cx16-asm.cfg memory.s
;
memtop		= $ff99
membot		= $ff9c
chrout		= $ffd2

;	.segment "STARTUP"
;	.segment "INIT"
;	.segment "ONCE"
;	.segment "CODE"

	.org 	$8000
	.export	LOADADDR = *

top_lo:		.byte 0 	; $..00
top_hi:		.byte 0		; $..01
bot_lo:		.byte 0		; $..02
bot_hi:		.byte 0		; $..03
ram_bank_no:	.byte 0		; $..04
rom_bank_no:	.byte 0		; $..05

; $..06
Main:		sec		; set carry flag
		jsr memtop
		stx top_lo
		sty top_hi
		sec		; just in case
		jsr membot
		stx bot_lo
		sty bot_hi	
		lda $9f60	; rom bank num
		sta rom_bank_no
		lda $9f61	; ram bank num
		sta ram_bank_no
		rts

