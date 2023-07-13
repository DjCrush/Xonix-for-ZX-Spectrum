;****************************************************************
; PLAYER MOVEMENT
;****************************************************************
Player        ld      ix, PlayerVariables
              ld      a, (last_k)         ; player's movement to the left
              cp      "5"
              jr      nz, Player1
              ld      (ix + offsetDX),-1
              ld      (ix + offsetDY),0
              jr      Player4
Player1       cp      "8"                 ; player's movement to the right
              jr      nz, Player2
              ld      (ix + offsetDX), 1
              ld      (ix + offsetDY), 0
              jr      Player4
Player2       cp      "6"                 ; player's downward movement
              jr      nz, Player3
              ld      (ix + offsetDX), 0
              ld      (ix + offsetDY), 1
              jr      Player4
Player3       cp      "7"                 ; upward movement of the player
              jr      nz, Player4
              ld      (ix + offsetDX), 0
              ld      (ix + offsetDY), -1
; check that the player is not out of the field
Player4       ld      b, (ix + offsetX)
              ld      a, (ix + offsetDX)
              add     a, b
              cp      -1
              jr      nz, Player5
              ld      (ix + offsetDX), 0
Player5       cp      FIELDWIDTH
              jr      nz, Player6
              ld      (ix + offsetDX), 0
Player6       ld      c, (ix + offsetY)
              ld      a, (ix + offsetDY)		
              add     a, c
              cp      -1
              jr      nz, Player7	
              ld      (ix + offsetDY), 0
Player7       cp      FIELDHEIGHT
              jr      nz, Player8
              ld      (ix + offsetDY), 0
; Destroy the old image and check where the player moves on land or sea.
Player8       call    ClearSprite
              ld      a, (varTraceExists)
              cp      TRUE
              ld      de, SpriteTrace
              ld      a, TRACE
              jr      z, Player9
              ld      de, SpriteLand  ; if is LAND
              ld      a, LAND
Player9       call    PutCharToField
              call    PutSprite

; move the player and save his new coordinates
              ld      a, (ix + offsetDX)
              add     a, b
              ld      (ix + offsetX), a
              ld      b, a
              ld      a, (ix + offsetDY)
              add     a, c
              ld      (ix + offsetY), a
              ld      c, a
; -----------
              call    GetCharFromField
              cp      TRACE               ; if you have hit your TRACE, remove one life
              jr      z, Player12
              cp      LAND
              jr      z, Player10
              ld      a, (varTraceExists)
              cp      TRUE
              jr      z, Player11
              ld      a, TRUE
              ld      (varTraceExists), a
              ld      a, b
              sub     (ix + offsetDX)
              ld      (ix + offsetOldX), a
              ld      a, c
              sub     (ix + offsetDY)
              ld      (ix + offsetOldY), a
              jr      Player11
Player10      ld      a, (varTraceExists)
              cp      FALSE
              jr      z, Player11
              ld      (ix + offsetDX), 0
              ld      (ix + offsetDY), 0
              call    FillingFieldArray
              ld      a, FALSE
              ld      (varTraceExists), a
Player11      ld      b, (ix + offsetX)
              ld      c, (ix + offsetY)
              ld      de, SpritePlayer
              call    PutSprite
              xor     a
              ld      (last_k), a
              ret
Player12      ld      hl, Lives
              ld      a, (hl)
              inc     hl
              or      (hl)
              cp      $30
              jr      nz, Player13
              ld      a, TRUE
              ld      (EndOfGame), a
              ret
Player13      call    DrawFieldArray
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
              jr      Player11
