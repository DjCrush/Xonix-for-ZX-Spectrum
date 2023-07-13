FillingFieldArray   push    ix
                    ld      ix, PlayerVariables
                    ld      b, (ix + offsetX)
                    ld      c, (ix + offsetY)
                    ld      a, LAND
                    call    PutCharToField
                    ld      ix, EnemyArray
                    ld      a, (NumberOfEnemies)
FillingFieldArray1  ex      af, af'
                    ld      b, (ix + offsetX)
                    ld      c, (ix + offsetY)
                    ld      a, LAND
                    call    PutCharToField  
                    ex      af, af'
                    dec     a               
                    jr      nz, FillingFieldArray1

                    ld      ix, BallArray
                    ld      a, (NumberOfBalls)
FillingFieldArray2  ex      af, af'
                    ld	    b, (ix + offsetX)
                    ld	    c, (ix + offsetY)
                    ld      a, EMPTY
                    call    PutCharToField
                    call    FillingFieldArray3
                    inc     ix
                    inc     ix
                    inc     ix
                    inc     ix
                    ex      af, af'
                    dec     a
                    jr      nz, FillingFieldArray2
                    call    ClearFieldArray
                    call    DrawFieldArray    
                    ld      de, 22 * 256 + 23
                    ld      hl, Full
                    call    PrintString 
                    ld      de, 7 * 256 + 23
                    ld      hl, Score
                    call    PrintString 
                    pop     ix                                   
                    ret
FillingFieldArray3  call    GetFieldAddr
                    ld      bc, FIELDWIDTH
FillingFieldArray4  ld      a, (hl)
                    cp      EMPTY
                    ret     nz
                    ld      (hl), TLAND
                    push    hl
                    dec     hl
                    call    FillingFieldArray4
                    pop     hl
                    push    hl
                    add	    hl, bc
                    call    FillingFieldArray4
                    pop	    hl
                    push    hl
                    inc	    hl
                    call    FillingFieldArray4
                    pop	    hl
                    or      a
                    sbc	    hl, bc
                    jp	    FillingFieldArray4
InitFieldArray      ld	    hl, FieldArray
                    ld	    de, FIELDWIDTH
                    ld	    bc, FIELDWIDTH * 256 + FIELDHEIGHT
                    ld	    a, LAND
                    call   	InitFieldArray1
                    ld      hl, FieldArray + FIELDWIDTH * 2 + 2
                    ld      bc, (FIELDWIDTH - 4) * 256 + FIELDHEIGHT - 4
                    ld      a, EMPTY
InitFieldArray1	    push    hl
                    push    bc
InitFieldArray2	    ld      (hl), a
                    inc     hl
                    djnz    InitFieldArray2
                    pop	    bc
                    pop	    hl
                    add	    hl, de
                    dec	    c
                    jr      nz, InitFieldArray1
                    ret
; do - return char from ArrayField
; in - BC coordinates x and y (B - x, C - y)
; out - A - char from ArrayField
; change - nothing
GetCharFromField    push    bc
                    push    hl
                    call    GetFieldAddr
                    ld	    a, (hl)
                    pop	    hl
                    pop     bc
                    ret

; do - put char in the ArrayField
; in - BC coordinates x and y (B - x, C - y)
; change - nothing
PutCharToField      push    bc
                    push    hl
                    call    GetFieldAddr
                    ld	    (hl), a
                    pop     hl
                    pop	    bc
                    ret	
GetFieldAddr        ld	    h, 0
                    ld	    l, c
                    dup     6
                    add	    hl, hl
                    edup    
                    ld	    c, b
                    ld	    b, 0
                    add     hl, bc
                    ld	    bc, FieldArray
                    add	    hl, bc
                    ret
ClearFieldArray     ld	    hl, FieldArray
                    ld	    bc, FIELDHEIGHT * FIELDWIDTH
                    ld      de, (tFull)
ClearFieldArray1    ld	    a, (hl)
                    cp	    TLAND
                    jr	    z, ClearFieldArray3
                    cp	    LAND
                    jr	    z, ClearFieldArray4
                    ld	    (hl), LAND
                    inc     de      ; count the number of shaded cells
                    push    hl
                    ld      hl, Score + 5
                    call    IncNumberinM
                    pop     hl
                    jr	    ClearFieldArray4
ClearFieldArray3    ld	    (hl), EMPTY
ClearFieldArray4    inc	    hl
                    dec	    bc
                    ld	    a, b
                    or	    c
                    jp	    nz, ClearFieldArray1
                    ld      (tFull), de
                    ld      hl, $3030
                    ld      (Full), hl
                    ex      de, hl
                    add     hl, hl
                    push    hl
                    add     hl, hl
                    add     hl, hl
                    pop     de
                    add     hl, de
                    ld      bc, 252
ClearFieldArray5    push    hl
                    ld      hl, Full + 1
                    call    IncNumberinM
                    pop     hl
                    or      a
                    sbc     hl, bc
                    jr      nc, ClearFieldArray5
                    ld      hl, Full + 1
                    call    DecNumberinM
                    ret
DrawFieldArray      ld	    hl, FieldArray
                    ld	    bc, 0
DrawFieldArray1     ld	    a, (hl)
                    cp	    EMPTY
                    jr	    z, DrawFieldArray3
                    cp      LAND
                    jr      nz, DrawFieldArray2
                    ld	    de, SpriteLand
                    call    PutSprite
                    jr      DrawFieldArray3
DrawFieldArray2     cp      TRACE
                    jr      nz, DrawFieldArray3
                    call    ClearSprite
                    ld      a, EMPTY
                    call    PutCharToField
         
DrawFieldArray3     inc	    hl
                    inc	    b
                    ld	    a, b
                    cp      FIELDWIDTH
                    jr	    c, DrawFieldArray1
                    ld	    b, 0
                    inc	    c
                    ld	    a, c
                    cp      FIELDHEIGHT
                    jr	    c, DrawFieldArray1
                    ret	 
