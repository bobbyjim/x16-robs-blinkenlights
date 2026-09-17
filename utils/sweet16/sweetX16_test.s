;
; SWEET16 Test Harness for Commander X16
; Loads SWEET16, runs bytecode test cases, reports results
;
; Build: cl65 --start-addr 0x0801 -t cx16 sweet16_test.s -C cx16-asm.cfg -o SWEET16TEST.PRG
;

.pc02
.org $0801
.export LOADADDR = *

; BASIC stub: 10 SYS2061
        .word $080b        ; next line address
        .word 10           ; line number
        .byte $9e          ; SYS token
        .byte "2061"       ; address
        .byte 0            ; end of line
        .word 0            ; end of program

; ================================================================
; CONSTANTS
; ================================================================
SWEET16_ENTRY = $0600       ; SWEET16 interpreter entry point
CHROUT        = $ffd2       ; KERNAL character output

; ZP registers (SWEET16 uses r0-r15 in ZP)
R0L  = $02
R0H  = $03
R1L  = $04
R1H  = $05
R2L  = $06
R2H  = $07

; Test framework state
TEST_COUNT    = $30
FAIL_COUNT    = $31
CURRENT_TEST  = $32

; ================================================================
; MAIN ENTRY
; ================================================================
START:
        ; Print banner
        LDX #0
@banner_loop:
        LDA BANNER_TEXT,X
        BEQ @banner_done
        JSR CHROUT
        INX
        BNE @banner_loop
@banner_done:
        
        ; Initialize test counters
        LDA #0
        STA TEST_COUNT
        STA FAIL_COUNT
        
        ; Run test suite
        JSR TEST_ADD
        JSR TEST_SUB
        JSR TEST_LDAT
        JSR TEST_BRANCH
        JSR TEST_SET_CONSTANT
        
        ; Print summary
        JSR PRINT_SUMMARY
        RTS

; ================================================================
; TEST: ADD operation (R0 = R0 + R1)
; ================================================================
TEST_ADD:
        INC TEST_COUNT
        LDA #1
        STA CURRENT_TEST
        
        ; Set initial values: R0 = 0x0005, R1 = 0x0003
        LDA #$05
        STA R0L
        LDA #$00
        STA R0H
        
        LDA #$03
        STA R1L
        LDA #$00
        STA R1H
        
        ; Call SWEET16 with ADD bytecode
        LDA #<BYTECODE_ADD
        PHA
        LDA #>BYTECODE_ADD
        PHA
        JSR SWEET16_ENTRY
        
        ; Check result: R0 should be 0x0008
        LDA R0L
        CMP #$08
        BNE @test_add_fail
        LDA R0H
        CMP #$00
        BNE @test_add_fail
        
        JSR PRINT_PASS
        RTS
        
@test_add_fail:
        INC FAIL_COUNT
        JSR PRINT_FAIL
        RTS

; ================================================================
; TEST: SUB operation (R0 = R0 - R1)
; ================================================================
TEST_SUB:
        INC TEST_COUNT
        LDA #2
        STA CURRENT_TEST
        
        ; Set initial values: R0 = 0x000A, R1 = 0x0004
        LDA #$0A
        STA R0L
        LDA #$00
        STA R0H
        
        LDA #$04
        STA R1L
        LDA #$00
        STA R1H
        
        ; Call SWEET16 with SUB bytecode
        LDA #<BYTECODE_SUB
        PHA
        LDA #>BYTECODE_SUB
        PHA
        JSR SWEET16_ENTRY
        
        ; Check result: R0 should be 0x0006
        LDA R0L
        CMP #$06
        BNE @test_sub_fail
        LDA R0H
        CMP #$00
        BNE @test_sub_fail
        
        JSR PRINT_PASS
        RTS
        
@test_sub_fail:
        INC FAIL_COUNT
        JSR PRINT_FAIL
        RTS

; ================================================================
; TEST: LDAT (load byte indirect, auto-increment pointer)
; ================================================================
TEST_LDAT:
        INC TEST_COUNT
        LDA #3
        STA CURRENT_TEST
        
        ; Set R1 to point to test data
        LDA #<TEST_DATA
        STA R1L
        LDA #>TEST_DATA
        STA R1H
        
        ; Call SWEET16: LDAT @R1 → R0 (load byte, increment R1)
        LDA #<BYTECODE_LDAT
        PHA
        LDA #>BYTECODE_LDAT
        PHA
        JSR SWEET16_ENTRY
        
        ; Check result: R0 should be 0x0042 (first byte of TEST_DATA)
        LDA R0L
        CMP #$42
        BNE @test_ldat_fail
        LDA R0H
        CMP #$00
        BNE @test_ldat_fail
        
        ; Check R1 was incremented
        LDA R1L
        CMP #<(TEST_DATA+1)
        BNE @test_ldat_fail
        LDA R1H
        CMP #>(TEST_DATA+1)
        BNE @test_ldat_fail
        
        JSR PRINT_PASS
        RTS
        
@test_ldat_fail:
        INC FAIL_COUNT
        JSR PRINT_FAIL
        RTS

; ================================================================
; TEST: Branch on Zero
; ================================================================
TEST_BRANCH:
        INC TEST_COUNT
        LDA #4
        STA CURRENT_TEST
        
        ; Set R0 = 0 (should trigger branch)
        LDA #$00
        STA R0L
        STA R0H
        
        ; Set R2 = sentinel value (0x00)
        LDA #$00
        STA R2L
        STA R2H
        
        ; Call SWEET16 with branch bytecode
        LDA #<BYTECODE_BRANCH
        PHA
        LDA #>BYTECODE_BRANCH
        PHA
        JSR SWEET16_ENTRY
        
        ; Check result: R2 should be 0x0099 (branch taken)
        LDA R2L
        CMP #$99
        BNE @test_branch_fail
        LDA R2H
        CMP #$00
        BNE @test_branch_fail
        
        JSR PRINT_PASS
        RTS
        
@test_branch_fail:
        INC FAIL_COUNT
        JSR PRINT_FAIL
        RTS

; ================================================================
; TEST: SET constant (immediate load)
; ================================================================
TEST_SET_CONSTANT:
        INC TEST_COUNT
        LDA #5
        STA CURRENT_TEST
        
        ; Clear R3
        LDA #$00
        STA R2L
        STA R2H
        
        ; Call SWEET16: SET R2 = 0x1234
        LDA #<BYTECODE_SET
        PHA
        LDA #>BYTECODE_SET
        PHA
        JSR SWEET16_ENTRY
        
        ; Check result: R2 should be 0x1234
        LDA R2L
        CMP #$34
        BNE @test_set_fail
        LDA R2H
        CMP #$12
        BNE @test_set_fail
        
        JSR PRINT_PASS
        RTS
        
@test_set_fail:
        INC FAIL_COUNT
        JSR PRINT_FAIL
        RTS

; ================================================================
; HELPER: Print pass/fail messages
; ================================================================
PRINT_PASS:
        LDA #'T'
        JSR CHROUT
        LDA #'E'
        JSR CHROUT
        LDA #'S'
        JSR CHROUT
        LDA #'T'
        JSR CHROUT
        LDA #' '
        JSR CHROUT
        LDA CURRENT_TEST
        CLC
        ADC #'0'
        JSR CHROUT
        LDA #':'
        JSR CHROUT
        LDA #' '
        JSR CHROUT
        LDA #'P'
        JSR CHROUT
        LDA #'A'
        JSR CHROUT
        LDA #'S'
        JSR CHROUT
        LDA #'S'
        JSR CHROUT
        LDA #13
        JSR CHROUT
        RTS

PRINT_FAIL:
        LDA #'T'
        JSR CHROUT
        LDA #'E'
        JSR CHROUT
        LDA #'S'
        JSR CHROUT
        LDA #'T'
        JSR CHROUT
        LDA #' '
        JSR CHROUT
        LDA CURRENT_TEST
        CLC
        ADC #'0'
        JSR CHROUT
        LDA #':'
        JSR CHROUT
        LDA #' '
        JSR CHROUT
        LDA #'F'
        JSR CHROUT
        LDA #'A'
        JSR CHROUT
        LDA #'I'
        JSR CHROUT
        LDA #'L'
        JSR CHROUT
        LDA #13
        JSR CHROUT
        RTS

PRINT_SUMMARY:
        LDA #13
        JSR CHROUT
        LDA #'-'
        JSR CHROUT
        LDA #'-'
        JSR CHROUT
        LDA #'-'
        JSR CHROUT
        LDA #'-'
        JSR CHROUT
        LDA #13
        JSR CHROUT
        
        LDA TEST_COUNT
        CLC
        ADC #'0'
        JSR CHROUT
        LDA #' '
        JSR CHROUT
        LDA #'T'
        JSR CHROUT
        LDA #'E'
        JSR CHROUT
        LDA #'S'
        JSR CHROUT
        LDA #'T'
        JSR CHROUT
        LDA #'S'
        JSR CHROUT
        LDA #','
        JSR CHROUT
        LDA #' '
        JSR CHROUT
        
        LDA FAIL_COUNT
        CLC
        ADC #'0'
        JSR CHROUT
        LDA #' '
        JSR CHROUT
        LDA #'F'
        JSR CHROUT
        LDA #'A'
        JSR CHROUT
        LDA #'I'
        JSR CHROUT
        LDA #'L'
        JSR CHROUT
        LDA #'E'
        JSR CHROUT
        LDA #'D'
        JSR CHROUT
        LDA #13
        JSR CHROUT
        RTS

; ================================================================
; BYTECODE TEST CASES
; ================================================================

; Test 1: ADD R0, R1 (opcode $A1)
BYTECODE_ADD:
        .byte $A1           ; ADD R0, R1
        .byte $00           ; RTN

; Test 2: SUB R0, R1 (opcode $B1)
BYTECODE_SUB:
        .byte $B1           ; SUB R0, R1
        .byte $00           ; RTN

; Test 3: LDAT @R1 → R0 (opcode $41)
BYTECODE_LDAT:
        .byte $41           ; LD @R1 (load byte indirect, auto-increment)
        .byte $00           ; RTN

; Test 4: BZ (branch if R0 zero)
BYTECODE_BRANCH:
        .byte $60           ; BZ R0, +4 (branch if R0 is zero)
        .byte $04           ; displacement (+4 bytes)
        .byte $12, $55, $00 ; SET R2, 0x0055 (skipped if branch taken)
        .byte $12, $34, $12 ; SET R2, 0x1234 (not executed)
        .byte $12, $99, $00 ; SET R2, 0x0099 (branch target)
        .byte $00           ; RTN

; Test 5: SET R2 = 0x1234 (opcode $12)
BYTECODE_SET:
        .byte $12           ; SET R2, imm16
        .byte $34, $12      ; 0x1234 (little-endian)
        .byte $00           ; RTN

; ================================================================
; DATA
; ================================================================
TEST_DATA:
        .byte $42, $43, $44, $45

BANNER_TEXT:
        .byte "SWEET16 TEST HARNESS", 13
        .byte "--------------------", 13, 0
