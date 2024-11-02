
; do - erases the sprite on the screen
; input - BC - x and y coordinates of the sprite (B - x,  C - y)
; output - nothing
; change - A, DE
EraseSprite:
    push	hl
    call    ConvertCoordBCToAdrHL
    bit	    0,b
    jp	    nz, EraseSprite2

EraseSprite1:
    dup     3
    ld	    a, (hl)
    and     $f
    ld	    (hl), a
    inc	    h
    edup
    ld	    a, (hl)
    and     $f
    ld	    (hl), a
    pop     hl
    ret

EraseSprite2:
    dup     3
    ld	    a, (hl)
    and     $f0
    ld	    (hl), a
    inc	    h
    edup
    ld	    a, (hl)
    and     $f0
    ld	    (hl), a
    pop     hl
    ret

; do - displays the sprite on the screen
; input - BC - x and y coordinates of the sprite on the screen (B - x, C -y)
; input - DE - the address of the sprite in RAM
; output - nothing
; change - A, DE
PutSprite:
    push	hl
    call    ConvertCoordBCToAdrHL
    bit	    0,b
    jp	    z, PutSprite2

PutSprite1:
    dup     3
    ld	    a, (de)
    and     $f
    or	    (hl)
    ld	    (hl), a
    inc	    de
    inc	    h
    edup
    ld	    a, (de)
    and     $f
    or	    (hl)
    ld	    (hl), a
    pop     hl
    ret		

PutSprite2:
    dup     3
    ld	    a, (de)
    and     $f0
    or	    (hl)
    ld	    (hl), a
    inc	    de
    inc	    h
    edup
    ld	    a, (de)
    and     $f0
    or	    (hl)
    ld	    (hl), a
    pop     hl
    ret
