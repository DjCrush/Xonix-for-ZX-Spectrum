;**********************************************************************************
; The movement of enemies over land
;**********************************************************************************
Enemy               ld      a, (varTraceExists)
                    cp      TRUE
                    jr      z, Enemy0
                    ld      ix, PlayerVariables
                    ld      b, (ix + offsetX)
                    ld      c, (ix + offsetY)
                    ld      a, HEADPL
                    call    PutCharToField
Enemy0              ld      ix, EnemyArray
                    ld      a, (NumberOfEnemies)
Enemy1              ex      af, af'

;******************************************************************************
; Checking the Enemy collision with the Player horizontally and vertically
;******************************************************************************
                    ld      b, (ix + offsetX)
                    ld      c, (ix + offsetY)
                    ld      a, (ix + offsetDX)
                    add     a, b
                    ld      b, a
                    call    GetCharFromField
                    cp	    HEADPL
                    jp	    z, Enemy6
                    ld      b, (ix + offsetX)
                    ld      c, (ix + offsetY)
                    ld	    a, (ix + offsetDY)
                    add	    a, c
                    ld	    c, a
                    call    GetCharFromField
                    cp	    HEADPL
                    jp	    z, Enemy6

;******************************************************************
; Checking the Enemy collision with the Player at a 45 degree angle
;******************************************************************
                    ld	    b, (ix + offsetX)
                    ld	    c, (ix + offsetY)
                    ld	    a, (ix + offsetDX)
                    add	    a, b
                    ld	    b, a
                    ld	    a, (ix + offsetDY)
                    add	    a, c
                    ld	    c, a
                    call    GetCharFromField
                    cp	    HEADPL
                    jp	    z, Enemy6
;******************************************************************
; Checking an opponent's collision with a LAND
;******************************************************************
                    ld      b, (ix + offsetX)
                    ld      c, (ix + offsetY)
                    ld      a, (ix + offsetDX)
                    add     a, b
                    cp      -1
                    jr      z, Enemy2
                    cp      FIELDWIDTH
                    jr      z, Enemy2
                    ld      b, a
                    call    GetCharFromField
                    cp      LAND
                    jr      z, Enemy3
Enemy2              ld      a, (ix + offsetDX)
                    neg
                    ld      (ix + offsetDX), a
Enemy3              ld      b, (ix + offsetX)
                    ld      c, (ix + offsetY)
                    ld      a, (ix + offsetDY)
                    add     a, c
                    cp      -1
                    jr      z, Enemy4
                    cp      FIELDHEIGHT
                    jr      z, Enemy4
                    ld      c, a
                    call    GetCharFromField
                    cp      LAND
                    jr      z, Enemy5
Enemy4              ld      a, (ix + offsetDY)
                    neg
                    ld      (ix + offsetDY), a
Enemy5              ld      b, (ix + offsetX)
                    ld      c, (ix + offsetY)
                    ld	    de, SpriteLand
                    call    PutSprite         ; deleting old enemy
                    ld      a, (ix + offsetDX)
                    add     a, b
                    ld      b, a
                    ld      (ix + offsetX), a
                    ld      a, (ix + offsetDY)
                    add     a, c
                    ld      c, a
                    ld      (ix + offsetY), a
                    call    ClearSprite		;	Deleting Enemy  
                    inc     ix
                    inc     ix
                    inc     ix
                    inc     ix
                    ex      af, af'
                    dec     a
                    jp      nz, Enemy1
                    ld      ix, PlayerVariables
                    ld      b, (ix + offsetX)
                    ld      c, (ix + offsetY)
                    ld      a, LAND
                    call    PutCharToField
                    ret
Enemy6              ld      hl, Lives + 1
                    call    DecNumberinM
                    ld      hl, Lives
                    ld      de, 35 * 256 + 23
                    call    PrintString  
                    ld      ix, PlayerVariables
                    ld      b, (ix + offsetX)
                    ld      c, (ix + offsetY)
                    ld      a, LAND
                    call    PutCharToField
                    call    ClearSprite
                    ld      de, SpriteLand
                    call    PutSprite
                    ld      (ix + offsetX), 32
                    ld      (ix + offsetY), 1
                    ld      (ix + offsetDX), 0
                    ld      (ix + offsetDY), 0
                    ld      ix, EnemyArray
                    ld      a, (NumberOfEnemies)
Enemy7              ex      af, af'
                    ld      b, (ix + offsetX)
                    ld      c, (ix + offsetY)
                    ld      de, SpriteLand
                    call    PutSprite
                    inc     ix
                    inc     ix
                    inc     ix
                    inc     ix
                    ex      af, af'
                    dec     a
                    jr      nz, Enemy7
                    ld      a, 1
                    ld      (NumberOfEnemies), a
                    ld      ix, EnemyArray
                    ld      (ix + offsetX), FIELDWIDTH / 2
                    ld      (ix + offsetY), FIELDHEIGHT - 1
                    ld      (ix + offsetDX), 1 
                    ld      (ix + offsetDY), 1
                    ld      hl, Lives
                    ld      a, (hl)
                    inc     hl
                    or      (hl)
                    cp      $30
                    ret     nz
                    ld      a, TRUE
                    ld      (EndOfGame), a
                    ret
