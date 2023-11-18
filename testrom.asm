        .title BBC Micro test ROM
        .sbttl David Knoll
        .module testrom
        .r6500
        .include "mos.inc"

; Sideways ROM header
        .area SWROM (ABS)
        .org 0x8000
        .db 0x00,0x00,0x00              ; No language entry
        jmp svcent                      ; Service entry
        .db 0x82                        ; Type- service, 6502
        .db <copy-1                     ; Copyright message pointer
        .db 0x00                        ; Binary version number
title:  .strz "David's test ROM"        ; Title string
copy:   .strz "(C)David Knoll"          ; Copyright string

; Service entry
svcent: cmp #0x04                       ; Unrecognised *command
        beq star
        cmp #0x09                       ; *HELP issued
        beq help
        rts

; *HELP handler
help:   lda [0xF2],y                    ; Keyword after *HELP
        cmp #'                          ; For now, if there's a keyword, it's not us
        bcs 3$
        jsr OSNEWL                      ; Newline

        ldx #0                          ; String pointer
1$:	lda title,x                     ; Get character
        beq 2$
        jsr OSWRCH
        inx                             ; Go back for next one
        jmp 1$
2$:     jsr OSNEWL                      ; Newline

        ldx 0xF4                        ; Restore A and X; these are known
3$:     lda #0x09
        rts

; *command handler
; Adapted/enhanced from "Sideways ROM authoring notes"
; https://www.sprow.co.uk/bbc/library/sidewrom.pdf
star:   tya                             ; Preserve Y
        pha
        ldx #0xFF                       ; Command table pointer
        dey                             ; Unrecognised command pointer

1$:     iny
        inx
        lda [0xF2],y                    ; Get character from command line
        and #0xDF                       ; Force upper case
        cmp cmdtbl,x                    ; If it matches, go back for next char
        beq 1$
        lda cmdtbl,x                    ; If bit 7 is set, it's an address in this ROM,
        bmi 3$                          ; ie we've found the end of the string

2$:     inx                             ; Seek to the end of the string
        lda cmdtbl,x
        bpl 2$
25$:    inx                             ; Skip over the address
        pla                             ; Restore pointer
        pha
        tay
        dey
        jmp 1$                          ; Go back to check for next command

3$:     cmp #0xFF                       ; End of table?
        beq 4$
        lda [0xF2],y                    ; Is the word in the command line
        cmp #'!                         ; longer than the matched command?
        bcs 25$
        pla                             ; Restore Y
        tay
        lda cmdtbl,x                    ; Stack high byte of address-1
        pha
        inx
        lda cmdtbl,x                    ; Stack low byte of address-1
        pha
        ldx 0xF4                        ; Restore A and X; these are known
        lda #0x04
        rts                             ; "Return" into command routine

4$:     pla                             ; Restore registers and return to MOS
        tay
        ldx 0xF4
        lda #0x04
        rts

; *command table
; Note the address is stored big-endian (for code efficiency above)
; and is 1 less than the actual symbol (as the PC increments after RTS)
        .macro cmdent name,addr
        .str name
        .db >(addr-1)
        .db <(addr-1)
        .endm

cmdtbl: cmdent "HELLO",hello
        cmdent "GOODBYE",gbye
        .db 0xFF                        ; End of table marker

; *HELLO
hello:  ldx #0                          ; String pointer
1$:     lda thello,x                    ; Get character
        beq 2$
        jsr OSWRCH                      ; Output character
        inx                             ; Go back for next one
        jmp 1$
2$:     jsr OSNEWL                      ; Newline
        ldx 0xF4                        ; Restore X
        lda #0                          ; Claim service call
        rts

; *GOODBYE
gbye:   ldx #0                          ; String pointer
1$:     lda tgbye,x                     ; Get character
        beq 2$
        jsr OSWRCH                      ; Output character
        inx                             ; Go back for next one
        jmp 1$
2$:     jsr OSNEWL                      ; Newline
        ldx 0xF4                        ; Restore X
        lda #0                          ; Claim service call
        rts

thello: .strz "Hello, World!"
tgbye:  .strz "Goodbye, World!"

; Placeholder for 16KB ROM size
        .org 0xBFFF
        .db 0x00
        .end
