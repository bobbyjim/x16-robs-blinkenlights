;
; cl65 -o furball.prg -t cx16 -C cx16-asm.cfg furball.s
;
chrout		= $ffd2

;	.segment "STARTUP"
;	.segment "INIT"
;	.segment "ONCE"
;	.segment "CODE"

		.org 	$8000
		.export	LOADADDR = *

; $8000 - $819f

alpha:		.byte 192, 192, 201, 65, 213, 192, 219, 46, 202, 192, 203, 46, 46, 46, 46, 0
beta:		.byte 194, 32, 32, 66, 171, 192, 201, 46, 202, 192, 203, 46, 46, 46, 46, 0
cella: 		.byte 213, 192, 192, 67, 202, 192, 192, 46, 32, 32, 32, 46, 46, 46, 46, 0
delta: 		.byte 32, 32, 194, 68, 213, 192, 179, 46, 202, 195, 203, 46, 46, 46, 46, 0
epsilon:	.byte 213, 192, 192, 69, 171, 192, 32, 46, 202, 192, 192, 46, 46, 46, 46, 0
digamma:	.byte 213, 195, 195, 70, 171, 192, 32, 46, 194, 32, 32, 46, 46, 46, 46, 0
gamma:		.byte 213, 192, 201, 71, 202, 192, 219, 46, 32, 192, 203, 46, 46, 46, 46, 0
heta:  		.byte 194, 32, 32, 72, 171, 192, 201, 46, 194, 32, 194, 46, 46, 46, 46, 0
iota:  		.byte 192, 178, 192, 73, 192, 177, 192, 46, 32, 32, 32, 46, 46, 46, 46, 0
jot: 		.byte 192, 178, 192, 74, 192, 203, 32, 46, 32, 32, 32, 46, 46, 46, 46, 0
kappa:		.byte 170, 164, 206, 75, 167, 163, 205, 46, 32, 32, 32, 46, 46, 46, 46, 0
lambda:		.byte 194, 32, 32, 76, 202, 192, 192, 46, 32, 32, 32, 46, 46, 46, 46, 0
mu:  		.byte 178, 178, 201, 77, 194, 194, 194, 46, 32, 32, 32, 46, 46, 46, 46, 0
nu:		.byte 178, 192, 201, 78, 194, 32, 194, 46, 32, 32, 32, 46, 46, 46, 46, 0
omicron:	.byte 213, 192, 201, 79, 202, 192, 203, 46, 32, 32, 32, 46, 46, 46, 46, 0
pi: 		.byte 213, 192, 201, 80, 171, 192, 203, 46, 194, 32, 32, 46, 46, 46, 46, 0
qoph:  		.byte 213, 195, 201, 81, 194, 32, 194, 46, 202, 178, 203, 46, 46, 46, 46, 0
rho: 		.byte 213, 195, 195, 82, 194, 32, 32, 46, 32, 32, 32, 46, 46, 46, 46, 0
sigma: 		.byte 213, 192, 195, 83, 202, 192, 201, 46, 195, 192, 203, 46, 46, 46, 46, 0
tau:		.byte 192, 178, 192, 84, 32, 194, 32, 46, 32, 32, 32, 46, 46, 46, 46, 0
upsilon:       	.byte 194, 32, 194, 85, 202, 192, 203, 46, 32, 32, 32, 46, 46, 46, 46, 0
vau:   		.byte 194, 32, 194, 86, 202, 192, 203, 46, 32, 32, 32, 46, 46, 46, 46, 0
wau:  		.byte 194, 194, 194, 87, 202, 177, 203, 46, 32, 32, 32, 46, 46, 46, 46, 0
xi:  		.byte 205, 164, 206, 88, 206, 163, 205, 46, 32, 32, 32, 46, 46, 46, 46, 0
ypsilon:       	.byte 205, 175, 206, 89, 32, 194, 32, 46, 32, 32, 32, 46, 46, 46, 46, 0
zeta: 		.byte 195, 195, 201, 90, 213, 195, 203, 46, 202, 195, 195, 46, 46, 46, 46, 0

; $81a0 - $81af

target0: 	.byte 0		; $81a0
		.byte 0		; $8101
target2:	.byte 0     	; $81a2
                .byte 0		; $81a3
target4:        .byte 0		; $81a4
                .byte 0		; $81a5
target6:        .byte 0		; $81a6
                .byte 0		; $81a7
target8:        .byte 0		; $81a8
                .byte 0		; $81a9
targeta:        .byte 0		; $81aa
                .byte 0		; $81ab
targetc:        .byte 0		; $81ac
                .byte 0		; $81ad
targete:        .byte 0		; $81ae
                .byte 0		; $81af

; $81b0 - $81ca
table_lo:	
	.byte <alpha
	.byte <beta
	.byte <cella
	.byte <delta
	.byte <epsilon
	.byte <digamma
	.byte <gamma
	.byte <heta
	.byte <iota
	.byte <jot
	.byte <kappa
	.byte <lambda
	.byte <mu
	.byte <nu
	.byte <omicron
	.byte <pi
	.byte <qoph
	.byte <rho
	.byte <sigma
	.byte <tau
	.byte <upsilon
	.byte <vau
	.byte <wau
	.byte <xi
	.byte <ypsilon
	.byte <zeta

; $81cb - $81e3
table_hi:
	.byte >alpha
	.byte >beta
	.byte >cella
	.byte >delta
	.byte >epsilon
	.byte >digamma
	.byte >gamma
	.byte >heta
	.byte >iota
	.byte >jot
	.byte >kappa
	.byte >lambda
	.byte >mu
	.byte >nu
	.byte >omicron
	.byte >pi
	.byte >qoph
	.byte >rho
	.byte >sigma
	.byte >tau
	.byte >upsilon
	.byte >vau
	.byte >wau
	.byte >xi
	.byte >ypsilon
	.byte >zeta

; $81e4-$81ef
	.word 0,0,0,0,0,0				; filler

; $81f0-$81ff
	.word 0,0,0,0,0,0,0,0				; filler

; $8200

Main:		lda target0
                cmp #32		; is this a space?
		bne putchar	; no

putspace:      	jsr twospaces
		jsr down
		jsr twoleft

          	jsr twospaces
		jsr down
		jsr twoleft

		jsr twospaces

		jmp done        ; mission accomplished

		;
		; Char to print is POKEd into target0.
		; Manipulate it to get our table index.
		;
putchar:	clc
		sbc #64
                sta target2	; for debugging
                tax             ; and put that in x
		;	
		; Set up our table pointer in $02-$03
		;
		lda table_lo,x
		sta $02
		lda table_hi,x
		sta $03
		;
		; $02-$03 indirectly points to the letter data
		;
 		ldy #0		; my pointer index
                jmp loop

position:	pha
		jsr down
		jsr twoleft
		jsr chrout ; and a third left
                pla
                iny
                iny

loop:		lda ($02),y
		jsr chrout
                iny
                lda ($02),y
		jsr chrout
		iny
                lda ($02),y
		jsr chrout
		cpy #10
                bcc position

done:           jsr up
		jsr chrout ; again

exit:		rts ; done

twospaces:	lda #32  		; two spaces
		jsr chrout
		jsr chrout
		rts
		
twoleft:	lda #157
		jsr chrout
		jsr chrout
		rts

down:		lda #17
		jsr chrout
		rts

up:		lda #145
		jsr chrout
		rts
