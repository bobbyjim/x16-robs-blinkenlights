;
;  I'm just going to write some assembly and see what happens, kk?
;

R0L     =   $02  ; accumulator low
R0H     =   $03  ; accumulator high
R14H    =   $1f  ; status high
R15L    =   $20  ; PC low
R15H    =   $21  ; PC high

;
; I'll set up a 16-bit short stack, just for fun.
; I've got from $22 to $7f 
;
XRL     =   $22  ; extended 16 bit stack, low bytes
XRH     =   $52  ; extended 16 bit stack, high bytes

.pc02                   ; enables 65C02

;
;   Set up some test data.
;
        LDX #$11     ; $0700+ = $11 $41 $15 $00
        STX $0700   
        LDX #$41
        STX $0701   
        LDX #$15
        STX $0702   
        LDX #$0
        STX $0703

        LDX #$7     ; R15 (PC) = $0700 
        STX $21
        LDX #$0     ; ... and now X is zero (conveniently)
        STX $20

;
;  The start address is in R15.
;
;  Fetch the instruction (zp fetch!)
;
FETCH:  LDA (R15L)
        BEQ DONE      ; 00 = PROGRAM END
        TAY           ; stash it in Y
        AND #$0F
        STA XRL,X     ; put the low nybble into RxL
        TYA           ; bring it back from Y
        AND #$F0
        STA XRH,X     ; put the high nybble into RxH
        CMP #0        ; is this a non-register op?
        BEQ NONREG    ;  - yes
REG_OP:               ;  - no
        
;
;  Increment R15 (the PC)
;
NEXT:   INC R15L
        BNE FETCH
        INC R15H
        BRA FETCH

DONE:   RTS

NONREG: RTS
