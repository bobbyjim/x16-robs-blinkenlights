;
; VM16: Direct-Threaded 16-bit Mini-VM for Commander X16
; Optimized for RPG maps, tiles, and state management.
;
; MEMORY LAYOUT:
;   Bank 0: $A000–$A01F = Entry point (NOPs, fall through)
;           $A020–$A800 = Main interpreter
;           $A800–$BFFF = Shared utilities/tables
;
;   Banks 1–7: $A000–$A01F = Per-bank entry (switch to Bank 0, jump to MAIN_LOOP)
;              $A100–$BFFF = Bytecode programs, data
;
; CALLING CONVENTION:
;   Set R9L = target bank (0 for main interpreter, or 1–7 for bytecode bank)
;   Set R0:R1 = bytecode start address (or relevant pointer)
;   JSR $A000 (entry point)
;   On return: R0:R1 contain result, VM_STATUS contains flags
;
; Author: [your name]
; Build: cl65 --start-addr 0xA000 -t cx16 vm16.s --config cx16-vm16.cfg -o VM16.PRG
;

.pc02
.org $A000
.export ENTRY = *

; ================================================================
; ENTRY POINT (Bank 0: NOPs and fall-through; all banks: JSR $A000)
; ================================================================
; In Bank 0, this is just a clear path to MAIN_LOOP.
; In Banks 1–7, this code switches to Bank 0 and jumps to MAIN_LOOP.
;
; To support both, we define ENTRY_STUB as a macro or just document
; that Banks 1–7 will have their own copy with the switch logic.

; For Bank 0:
ENTRY:
        ; Fall through to MAIN_LOOP (or could be NOP stubs if needed)
        BRA MAIN_LOOP

; ================================================================
; REGISTER FILE (in ZP)
; ================================================================
R0L  = $02
R0H = $03
R1L  = $04
R1H = $05
R2L  = $06
R2H = $07
R3L  = $08
R3H = $09
R4L  = $0A
R4H = $0B
R5L  = $0C
R5H = $0D
R6L  = $0E
R6H = $0F
R7L  = $10
R7H = $11
R9L  = $12        ; Current bank (set by caller)
R9H  = $13        ; (high byte, often unused but kept for consistency)

; VM state in ZP (above registers)
VM_IP    = $14        ; VM instruction pointer (16-bit), points to next opcode
VM_STATUS = $16       ; status flags (bit 0 = ZF, bit 1 = CF)

; Saved 6502 state (if needed for nested calls)
SAVE_ACC  = $17
SAVE_X    = $18
SAVE_Y    = $19
SAVE_P    = $1A

; ================================================================
; MAIN DISPATCH LOOP
; ================================================================
MAIN_LOOP:
        LDY #0
        LDA (VM_IP),Y       ; fetch opcode at current IP
        
        ; Opcode × 2 for 16-bit handler address indexing
        ASL
        TAX
        
        ; Increment IP (handlers will do the rest)
        INC VM_IP
        BNE .skip_hi
        INC VM_IP + 1
.skip_hi:
        
        ; Jump to handler
        JMP (HANDLER_TABLE,X)

; ================================================================
; HANDLER IMPLEMENTATIONS
; ================================================================

; 0x10: LDW r_dst, r_base, disp8
;   Load 16-bit word from [r_base + disp8] → r_dst
HANDLER_LDW:
        LDY #0
        LDA (VM_IP),Y       ; r_dst (0–7)
        PHA                 ; save for later indexing
        
        INY
        LDA (VM_IP),Y       ; r_base (0–7)
        ASL                 ; × 2 for 16-bit indexing
        TAX
        
        INY
        LDA (VM_IP),Y       ; disp8 (signed)
        
        ; Compute address: r_base + disp8
        CLC
        ADC R0L,X           ; add displacement to base low byte
        STA .addr_lo
        LDA R0H,X           ; base high byte
        ADC #0              ; carry into high byte
        STA .addr_hi
        
        ; Load from computed address
        LDY #0
        LDA (.addr_lo),Y
        
        PLA                 ; restore r_dst
        ASL
        TAX
        STA R0L,X           ; store low byte
        
        LDY #1
        LDA (.addr_lo),Y
        STA R0H,X           ; store high byte
        
        ; Advance VM_IP by 3 bytes
        LDA VM_IP
        CLC
        ADC #3
        STA VM_IP
        BCC MAIN_LOOP
        INC VM_IP + 1
        JMP MAIN_LOOP
        
.addr_lo: .byte 0
.addr_hi: .byte 0

; 0x11: LDB r_dst, r_base, disp8
;   Load 8-bit byte from [r_base + disp8], zero-extend → r_dst
HANDLER_LDB:
        LDY #0
        LDA (VM_IP),Y       ; r_dst (0–7)
        PHA
        
        INY
        LDA (VM_IP),Y       ; r_base (0–7)
        ASL
        TAX
        
        INY
        LDA (VM_IP),Y       ; disp8
        
        ; Compute address
        CLC
        ADC R0L,X
        STA .addr_lo
        LDA R0H,X
        ADC #0
        STA .addr_hi
        
        ; Load byte
        LDY #0
        LDA (.addr_lo),Y
        
        PLA
        ASL
        TAX
        STA R0L,X           ; store low byte
        LDA #0
        STA R0H,X           ; zero high byte
        
        ; Advance VM_IP by 3
        LDA VM_IP
        CLC
        ADC #3
        STA VM_IP
        BCC MAIN_LOOP
        INC VM_IP + 1
        JMP MAIN_LOOP
        
.addr_lo: .byte 0
.addr_hi: .byte 0

; 0x20: LDI r_dst, imm16_LE
;   Load immediate 16-bit value → r_dst
HANDLER_LDI:
        LDY #0
        LDA (VM_IP),Y       ; r_dst (0–7)
        ASL
        TAX
        
        INY
        LDA (VM_IP),Y       ; imm16 low byte
        STA R0L,X
        
        INY
        LDA (VM_IP),Y       ; imm16 high byte
        STA R0H,X
        
        ; Advance VM_IP by 3
        LDA VM_IP
        CLC
        ADC #3
        STA VM_IP
        BCC MAIN_LOOP
        INC VM_IP + 1
        JMP MAIN_LOOP

; 0x30: MOV r_dst, r_src
;   r_dst ← r_src
HANDLER_MOV:
        LDY #0
        LDA (VM_IP),Y       ; r_dst
        ASL
        TAX
        
        INY
        LDA (VM_IP),Y       ; r_src
        ASL
        TAY
        
        ; Copy 16-bit value from r_src to r_dst
        LDA R0L,Y
        STA R0L,X
        LDA R0H,Y
        STA R0H,X
        
        ; Advance VM_IP by 2
        LDA VM_IP
        CLC
        ADC #2
        STA VM_IP
        BCC MAIN_LOOP
        INC VM_IP + 1
        JMP MAIN_LOOP

; 0x31: ADD r_dst, r_src
;   r_dst ← r_dst + r_src (set ZF, CF)
HANDLER_ADD:
        LDY #0
        LDA (VM_IP),Y       ; r_dst
        ASL
        TAX
        
        INY
        LDA (VM_IP),Y       ; r_src
        ASL
        TAY
        
        ; Add: r_dst + r_src
        CLC
        LDA R0L,X
        ADC R0L,Y
        STA R0L,X
        LDA R0H,X
        ADC R0H,Y
        STA R0H,X
        
        ; Set status flags (simplified: just ZF)
        ORA R0L,X
        BEQ .add_zero
        LDA #0              ; non-zero
        BNE .add_done
.add_zero:
        LDA #1              ; zero flag
.add_done:
        STA VM_STATUS
        
        ; Advance VM_IP by 2
        LDA VM_IP
        CLC
        ADC #2
        STA VM_IP
        BCC MAIN_LOOP
        INC VM_IP + 1
        JMP MAIN_LOOP

; 0x32: SUB r_dst, r_src
;   r_dst ← r_dst - r_src (set ZF, CF)
HANDLER_SUB:
        LDY #0
        LDA (VM_IP),Y       ; r_dst
        ASL
        TAX
        
        INY
        LDA (VM_IP),Y       ; r_src
        ASL
        TAY
        
        ; Subtract: r_dst - r_src
        SEC
        LDA R0L,X
        SBC R0L,Y
        STA R0L,X
        LDA R0H,X
        SBC R0H,Y
        STA R0H,X
        
        ; Set status flags
        ORA R0L,X
        BEQ .sub_zero
        LDA #0
        BNE .sub_done
.sub_zero:
        LDA #1
.sub_done:
        STA VM_STATUS
        
        ; Advance VM_IP by 2
        LDA VM_IP
        CLC
        ADC #2
        STA VM_IP
        BCC MAIN_LOOP
        INC VM_IP + 1
        JMP MAIN_LOOP

; 0x40: INC r
;   r ← r + 1
HANDLER_INC:
        LDY #0
        LDA (VM_IP),Y       ; r (0–7)
        ASL
        TAX
        
        INC R0L,X
        BNE MAIN_LOOP
        INC R0H,X
        
        ; Advance VM_IP by 1
        INC VM_IP
        BNE MAIN_LOOP
        INC VM_IP + 1
        JMP MAIN_LOOP

; 0x41: DEC r
;   r ← r - 1
HANDLER_DEC:
        LDY #0
        LDA (VM_IP),Y       ; r (0–7)
        ASL
        TAX
        
        LDA R0L,X
        BNE .dec_no_borrow
        DEC R0H,X
.dec_no_borrow:
        DEC R0L,X
        
        ; Advance VM_IP by 1
        INC VM_IP
        BNE MAIN_LOOP
        INC VM_IP + 1
        JMP MAIN_LOOP

; 0xFF: RET
;   Return to 6502 code
HANDLER_RET:
        RTS

; ================================================================
; HANDLER TABLE
; ================================================================
; Indexed by opcode × 2. Opcode 0x00–0xFF → 256 entries.
;
.align 256
HANDLER_TABLE:
        ; 0x00–0x0F: unused
        .repeat 16
        .word HANDLER_NOP
        .endrepeat
        
        ; 0x10: LDW
        .word HANDLER_LDW
        ; 0x11: LDB
        .word HANDLER_LDB
        
        ; 0x12–0x1F: unused
        .repeat 14
        .word HANDLER_NOP
        .endrepeat
        
        ; 0x20: LDI
        .word HANDLER_LDI
        
        ; 0x21–0x2F: unused
        .repeat 15
        .word HANDLER_NOP
        .endrepeat
        
        ; 0x30: MOV
        .word HANDLER_MOV
        ; 0x31: ADD
        .word HANDLER_ADD
        ; 0x32: SUB
        .word HANDLER_SUB
        
        ; 0x33–0x3F: unused
        .repeat 13
        .word HANDLER_NOP
        .endrepeat
        
        ; 0x40: INC
        .word HANDLER_INC
        ; 0x41: DEC
        .word HANDLER_DEC
        
        ; 0x42–0xFF: unused (fill with NOP)
        .repeat (256 - 0x42)
        .word HANDLER_NOP
        .endrepeat

; ================================================================
; NOP HANDLER
; ================================================================
HANDLER_NOP:
        INC VM_IP
        BNE MAIN_LOOP
        INC VM_IP + 1
        JMP MAIN_LOOP
