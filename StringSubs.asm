; do - displays the string
; input - hl - adr of string in RAM
; input - de - Coordinates X and Y on the screen
; output - nothing
PrintString:
    ld      a, (hl)
    and     a
    ret     z
    call    PrintChar
    inc     hl
    inc     d
    jp      PrintString

PrintChar:
    push    bc, de, hl
    ld      l, a
    ld      h, 0
    add     hl, hl
    add     hl, hl
    add     hl, hl
    ld      bc, font8x4
    add     hl, bc
    ld      a, $f
    bit     0, d
    jr      nz, PrintChar1
    ld      a, $f0

PrintChar1:
    ld      (PrintChar3 + 1), a
    cpl
    ld      (PrintChar4 + 1), a
    call    GetAddrScr
 
    ld      b, 8
PrintChar2:
    ld      a, (hl)

PrintChar3:
    and     $f0
    ld      c, a
    ld      a, (de)
PrintChar4:
    and     $0f
    or      c
    ld      (de), a
    inc     d
    inc     l
    djnz    PrintChar2
    pop     hl, de, bc
    ret

; do - displays a double-height string on the screen
; input - hl - adr of string in RAM
; input - de - Coordinates X and Y on the screen
; output - nothing
PrintStringB:
    ld      a, (hl)
    and     a
    ret     z
    call    PrintCharB
    inc     hl
    inc     d
    jp      PrintStringB

PrintCharB:
    push    bc, de, hl
    ld      l, a
    ld      h, 0
    add     hl, hl
    add     hl, hl
    add     hl, hl
    ld      bc, font8x4
    add     hl, bc
    ld      a, $f
    bit     0, d
    jr      nz, PrintCharB1
    ld      a, $f0

PrintCharB1:
    ld      (PrintCharB3 + 1), a
    ld      (PrintCharB5 + 1), a
    cpl
    ld      (PrintCharB4 + 1), a
    ld      (PrintCharB6 + 1), a
    call    GetAddrScr
    ld      b, 8

PrintCharB2:
    ld      a, (hl)

PrintCharB3:
    and     $f0
    ld      c, a
    ld      a, (de)

PrintCharB4:
    and     $0f
    or      c
    ld      (de), a
    inc     d
    ld      a, (hl)

PrintCharB5:
    and     $f0
    ld      c, a
    ld      a, (de)

PrintCharB6:
    and     $0f
    or      c
    ld      (de), a
    call    DownLineDE
    inc     l
    djnz    PrintCharB2
    pop     hl, de, bc
    ret