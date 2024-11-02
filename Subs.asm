ConvertCoordBCToAdrHL   ld    h, $fe   ; define screen addr
                        ld    l, c
                        ld    a, (hl)
                        inc   h
                        ld    h, (hl)
                        ld    l, a
                        ld    a, (VirtualScreenOnOFF)
                        xor   h
                        ld    h, a
                        ld    a, b
                        srl   a
                        add   a, l
                        ld    l, a
                        ret
; do - gets the address of the icon area in the screen area
; in - DE - xy coord (x - D, y - E)
; out - DE - address in the screen area
; change - A
GetAddrScr:
    ld    a, (VirtualScreenOnOFF)
    ld    b, a
    ld    a, e
    ld    c, e
    rrca
    rrca
    rrca
    and   $e0
    ld    e,a
    ld    a,d
    rrca
    and   $1f
    add   a,e
    ld    e,a
    ld    a,c
    and   $18
    or    $40
    xor   b
    ld    d,a
    ret

IncNumberinM:
    inc   (hl)
    ld    a, (hl)
    cp    $3a
    ret   nz
    ld    (hl), $30
    dec   hl
    jp    IncNumberinM

DecNumberinM:
    dec   (hl)
    ld    a, (hl)
    cp    $2f
    ret   nz
    ld    (hl), $39
    dec   hl
    jp    DecNumberinM

DownLineDE:
    inc   d
    ld    a, d
    and   7
    ret   nz
    ld    a, e
    add   a, 32
    ld    e, a
    ret   c
    ld    a, d
    sub   8
    ld    d, a
    ret

UpLineDE:
    ld    a, d
    dec   d
    and   7
    ret   nz
    ld    a, e
    sub   32
    ld    e, a
    ret   c
    ld    a, d
    add   a, 8
    ld    d, a
    ret


; do : clear screen buffer with attribute buffer
; in : nothing
; out : nothing
; change : a, bc, de, hl
ClearMemoryBlock:
    ld   (ClearMemoryBlock2 + 1), sp
    ld   sp, hl
    ld   d, a
    ld   e, a

ClearMemoryBlock1:
    dup  16
    push de
    edup
    djnz    ClearMemoryBlock1

ClearMemoryBlock2:
    ld      sp, 0
    ret



;****************************************
; GENERATE RANDOM NUMBERS...
;****************************************
Random:                 
    push    de, hl
    ld      hl, Rand1
    ld      e, (hl)
    inc     l
    ld      d, (hl)
    inc     l
    ld      a, r
    xor     (hl)
    xor     e
    xor     d
    rlca
    rlca
    rlca
    srl     e
    srl     d
    ld      (hl),d
    dec     l
    ld      (hl),e
    dec     l
    ld      (hl),a
    pop     hl, de
    ret

ClearScreenLine:
    ld      (ClearScreenLine3 + 1), hl
    ld      de, $57e0
    ld      hl, $4000
    ld      b, 96

ClearScreenLine1:
    push    bc, de, hl
    xor     a
    ld      b, 32

ClearScreenLine2:
    ld      (de), a
    ld      (hl), a
    inc     e
    inc     l
    djnz    ClearScreenLine2
    ld      de, 26 * 256 + 11

ClearScreenLine3:
    ld      hl, 0
    call    PrintStringB
    ld      hl, $5960 + 26 + 19
    ld      b, 5

ClearScreenLine4:
    ld      (hl), 5
    inc     l
    djnz    ClearScreenLine4
    ei 
    halt
    di
    pop     hl
    ex      de, hl
    call    DownLineDE
    ex      de, hl
    pop     de
    call    UpLineDE
    pop     bc
    djnz    ClearScreenLine1
    ret

CopyScreenLineE:
    ld      hl, $4f60   ; 8f60
    ld      de, $4880   ; 8860
    ld      b, 96
CopyScreenLineE1:

    push    bc, de, hl, de
    ld      d, h
    ld      a, h
    xor     $c0
    ld      h, a
    ld      e, l
    ld      bc, 32
    ldir
    pop     de
    ld      a, d
    xor     $c0
    ld      h, a
    ld      l, e
    ld      bc, 32
    ldir
    ld      b, 1
    call    Delay
    pop     hl
    ex      de, hl
    call    UpLineDE
    ex      de, hl
    pop     de
    call    DownLineDE
    pop     bc
    djnz    CopyScreenLineE1
    ret

CopyScreenLine:
    ld      hl, (Level)
    ld      (TextLevel2 + 6), hl
    ld      hl, $4f60   ; 8f60
    ld      de, $4880   ; 8860
    ld      b, 96

CopyScreenLine1:
    push    bc, de, hl, de
    ld      d, h
    ld      a, h
    xor     $c0
    ld      h, a
    ld      e, l
    ld      bc, 32
    ldir
    pop     de
    ld      a, d
    xor     $c0
    ld      h, a
    ld      l, e
    ld      bc, 32
    ldir
    ld      hl, TextLevel2
    ld      de, 28 * 256 + 11
    call    PrintStringB
    ld      b, 1
    call    Delay
    pop     hl
    ex      de, hl
    call    UpLineDE
    ex      de, hl
    pop     de
    call    DownLineDE
    pop     bc
    djnz    CopyScreenLine1
    ld      b, 30
    call    Delay
    ld      hl, ADRVIRTSCREEN
    ld      de, $4000
    ld      bc, $1800
    ldir
    ret

Delay:
    push    bc
    ei
Delay1:
    halt
    djnz    Delay1
    di
    pop     bc
    ret