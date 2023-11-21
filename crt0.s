        .export _exit
        .export __STARTUP__ : absolute = 1      ; Mark as startup
        .import zerobss
        .import initlib, donelib
        .import _language, _service
        .import __STACKSTART__                  ; Linker generated

        .importzp sp, sreg
        .include "zeropage.inc"

; Sideways ROM header
        .segment "STARTUP"
        jmp langent
        jmp svcent
        .byte $C2
        .byte <copy-1
        .byte $00
title:  .asciiz "CRT0"
copy:   .asciiz "(C)"

; Language entry
langent:
        php
        sei
        cld
        sta regsv+0
        stx regsv+1
        sty regsv+2
        pla
        sta regsv+3
        tsx
        stx spsave
        lda #<regsv
        ldx #>regsv
        jsr _language
        lda regsv+3
        pha
        ldy regsv+2
        ldx regsv+1
        lda regsv+0
        plp
        rts

; Service entry
svcent: php
        sei
        cld
        sta regsv+0
        stx regsv+1
        sty regsv+2
        cmp #1
        bne :+
        jsr init
:       pla
        sta regsv+3
        tsx
        stx spsave
        lda #<regsv
        ldx #>regsv
        jsr _service
        lda regsv+3
        pha
        ldy regsv+2
        ldx regsv+1
        lda regsv+0
        plp
        rts

init:   lda #<__STACKSTART__
        ldx #>__STACKSTART__
        sta sp
        stx sp+1
        jsr zerobss
        jsr initlib
        rts

_exit:  ldx spsave
        txs
        jsr donelib
        lda regsv+3
        pha
        ldy regsv+2
        ldx regsv+1
        lda regsv+0
        plp
        rts

        .segment "DATA"
spsave: .res 1
regsv:  .res 6
