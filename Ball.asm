;**********************************************************************************
; ball movement
;**********************************************************************************
Ball                ld      ix, BallArray
                    ld	    a, (NumberOfBalls)
Ball1               ex	    af, af'
                    ld	    b, (ix + offsetX)	;deleting old ball
                    ld	    c, (ix + offsetY)
                    call    ClearSprite
                    ld	    a, (ix + offsetDX)		
                    add     a, b  ;	x = x + dx
                    ld	    (ix + offsetX),a
                    ld	    a, (ix + offsetDY)
                    add     a, c  ;	y = y + dy
                    ld	    (ix + offsetY), a
;********************************************************************
; Checking the Ball collision with the TRACE horizontally and vertically
;********************************************************************
                    ld      a, (varTraceExists)
                    cp      FALSE
                    jp      z, Ball3
                    push    ix
                    ld      ix, PlayerVariables
                    ld      b, (ix + offsetX)
                    ld      c, (ix + offsetY)
                    ld      a, TRACE
                    call    PutCharToField
                    pop     ix
                    ld      b, (ix + offsetX)
                    ld      c, (ix + offsetY)
                    ld      a, (ix + offsetDX)
                    add     a, b
                    ld      b, a
                    call    GetCharFromField
                    cp	    TRACE
                    jp      z, Ball7
                    ld      b, (ix + offsetX)
                    ld      c, (ix + offsetY)
                    ld	    a, (ix + offsetDY)
                    add     a, c
                    ld      c, a
                    call    GetCharFromField
                    cp	    TRACE
                    jp      z, Ball7
;**************************************************************
; Checking a ball collision with the TRACE at a 45 degree angle
;**************************************************************
Ball2               ld	    b, (ix + offsetX)
                    ld	    c, (ix + offsetY)
                    ld	    a, (ix + offsetDX)
                    add     a, b
                    ld	    b, a
                    ld	    a, (ix + offsetDY)
                    add     a, c
                    ld	    c, a
                    call    GetCharFromField
                    cp	    TRACE
                    jr	    z, Ball7
;***************************************************************	
; Check ball collision with LAND horizontally and vertically
;***************************************************************
Ball3               ld      b, (ix + offsetX)
                    ld      c, (ix + offsetY)
                    ld      a, (ix + offsetDX)
                    add     a, b
                    ld      b, a
                    call    GetCharFromField
                    cp	    EMPTY
                    jr	    z, Ball4
                    ld	    a, (ix + offsetDX)
                    neg
                    ld	    (ix + offsetDX), a
Ball4               ld      b, (ix + offsetX)
                    ld      c, (ix + offsetY)
                    ld	    a, (ix + offsetDY)
                    add     a, c
                    ld	    c, a
                    call    GetCharFromField
                    cp	    EMPTY
                    jr	    z, Ball5
                    ld	    a, (ix + offsetDY)
                    neg
                    ld	    (ix + offsetDY),a

;**************************************************************
; Checking a ball collision with a LAND at a 45 degree angle
;**************************************************************
Ball5               ld	    b, (ix + offsetX)
                    ld	    c, (ix + offsetY)
                    ld	    a, (ix + offsetDX)
                    add     a, b
                    ld	    b, a
                    ld	    a, (ix + offsetDY)
                    add     a, c
                    ld	    c, a
                    call    GetCharFromField
                    cp	    EMPTY
                    jr	    z, Ball6
                    ld	    a, (ix + offsetDX)
                    neg
                    ld	    (ix + offsetDX), a
                    ld	    a, (ix + offsetDY)
                    neg
                    ld	    (ix + offsetDY), a
;****************************************************	
; Drawing a ball on the screen
;****************************************************
Ball6               ld	    b, (ix + offsetX)	
                    ld	    c, (ix + offsetY)
                    ld	    de, SpriteBall				
                    call    PutSprite  ;	Drawing a new ball
                    inc     ix
                    inc     ix
                    inc     ix
                    inc     ix
                    ex      af, af'
                    dec     a
                    jp      nz, Ball1
                    ret		

Ball7               ld      hl, Lives
                    ld      a, (hl)
                    inc     hl
                    or      (hl)
                    cp      $30
                    jr      nz, Ball8
                    ld      a, TRUE
                    ld      (EndOfGame), a
                    ret
Ball8               call    DrawFieldArray
                    push    ix
                    ld      ix, PlayerVariables
                    ld      b, (ix + offsetX)
                    ld      c, (ix + offsetY)
                    call    ClearSprite
                    ld      (ix + offsetDX), 0
                    ld      (ix + offsetDY), 0
                    ld      a, (ix + offsetOldX)
                    ld      (ix + offsetX), a
                    ld      a, (ix + offsetOldY)
                    ld      (ix + offsetY), a
                    ld      b, (ix + offsetX)
                    ld      c, (ix + offsetY)
                    ld      a, FALSE
                    ld      (varTraceExists), a
                    ld      de, SpritePlayer
                    call    PutSprite
                    ld      hl, Lives + 1
                    call    DecNumberinM
                    ld      hl, Lives
                    ld      de, 35 * 256 + 23
                    call    PrintString                    
                    pop     ix  
                    jp      Ball5
;-----------------------------------------------------------------------------------------
; end of moving Balls
;-----------------------------------------------------------------------------------------
