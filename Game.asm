Game	ld      a, 1
		ld      (NumberOfBalls), a
		ld      a, FALSE
		ld      (EndOfGame), a
		ld      hl, $3030
		ld      (Score), hl
		ld      (Score + 2), hl
		ld      (Score + 4), hl
		ld      hl, $3034
		ld      (Lives), hl
		ld      hl, $3130
		ld      (Level), hl
Game1	ld      a, VSON
		ld      (VirtualScreenOnOFF), a   ; everything is displayed in the virtual screen
		ld      a, 1
		ld      (NumberOfEnemies), a
		ld      hl, $3030
		ld      (Full), hl
		ld      a, '%'
		ld      (Full + 2), a
		ld      (Time), hl
		ld      (Time + 2), hl
		ld      (Time + 4), hl
		ld      hl, 0
		ld      (tFull), hl
		xor     a, a
		ld      hl, $9800
		ld      b, 192
		call    ClearMemoryBlock   ; clearing the virtual screen
		call    InitFieldArray
		call    DrawFieldArray
		ld		ix, PlayerVariables
		ld		(ix + offsetX), 32
		ld		(ix + offsetY), 1
		ld		(ix + offsetDX), 0
		ld		(ix + offsetDY), 0
		ld      bc, 32 * 256 + 1
		ld      de, SpritePlayer
		call    PutSprite
		ld      a, FALSE
		ld      (varTraceExists), a
		ld      ix, BallArray
		ld      a, (NumberOfBalls)
Game2	push    af
		call    Random
		ld      a, (Rand2)
		add     a, 3                   
		and     $3f
		cp      FIELDWIDTH - 4
		jr      c, Game3
		sub     5
Game3	ld		(ix + offsetX), a
		ld      b, a
		call    Random
		ld      a, (Rand1)
		add     a, 3
		and     $2f
		cp      FIELDHEIGHT - 5
		jr      c, Game4
		sub     5
Game4	ld		(ix + offsetY), a
		ld      c, a
		ld      de, SpriteBall
		call    PutSprite
		ld      a, (ix + offsetX)
		call    Random
		ld      a, (Rand2)
		cp      32
		ld		(ix + offsetDX), 1
		jr      c, Game5
		ld		(ix + offsetDX), -1
Game5	call    Random
		ld      a, (Rand2)
		cp      32
		ld		(ix + offsetDY), 1
		jr  	c, Game6
		ld		(ix + offsetDY), -1
Game6	.4 inc     ix
		pop     af
		dec     a
		jp      nz, Game2

		ld      ix, EnemyArray
		ld		(ix + offsetX), FIELDWIDTH / 2
		ld		(ix + offsetY), FIELDHEIGHT - 1
		ld		(ix + offsetDX), 1 
		ld		(ix + offsetDY), 1
		ld      b, (ix + offsetX)
		ld      c, (ix + offsetY)
		call    ClearSprite
		
		ld      a, $7
		ld      hl, $5b00
		ld      b, 1
		call    ClearMemoryBlock
		ld      hl, $5b00 - $20
		ld      b, 23
		ld      a, $4
		call    ClearMemoryBlock
		ld      de, 0 * 256 + 23
		ld      hl, TextScore
		call    PrintString
		ld      de, 7 * 256 + 23
		ld      hl, Score
		call    PrintString
		ld      de, 16 * 256 + 23
		ld      hl, TextFull
		call    PrintString
		ld      de, 22 * 256 + 23
		ld      hl, Full
		call    PrintString
		ld      de, 28 * 256 + 23
		ld      hl, TextLives
		call    PrintString
		ld      de, 35 * 256 + 23
		ld      hl, Lives
		call    PrintString
		ld      de, 40 * 256 + 23
		ld      hl, TextLevel
		call    PrintString
		ld      de, 47 * 256 + 23
		ld      hl, Level
		call    PrintString
		ld      de, 52 * 256 + 23
		ld      hl, TextTime
		call    PrintString
		ld      hl, Time
		ld      de, 58 * 256 + 23
		call    PrintString
		ld      a, VSOFF
		ld      (VirtualScreenOnOFF), a
		call    CopyScreenLine
Game7	call    Player
		call	Ball
		call    Enemy
		ld      b, 1
		call    Delay
		ld      a, (Time + 2)
		ld      b, a
		ld      hl, Time + 5
		call    IncNumberinM
		ld      a, (Time + 2)
		cp      b
		jr      z, Game8
		ld      a, (NumberOfEnemies)
		ld      e, a
		ld      d, 0
		rl      de
		or      a
		rl      de
		ld      ix, EnemyArray
		add     ix, de
		ld		(ix + offsetX), FIELDWIDTH / 2
		ld		(ix + offsetY), FIELDHEIGHT - 1
		ld		(ix + offsetDX), 1 
		ld		(ix + offsetDY), 1 
		ld      hl, NumberOfEnemies
		inc     (hl)
Game8	ld      de, 58 * 256 + 23
		ld      hl, Time
		call    PrintString
		ld      hl, 1890
		ld      bc, (tFull)   ;  75% of the poured surface - transition to the next level
		or      a
		sbc     hl, bc
		jr      c, Game9
		ld      a, (EndOfGame)
		cp      FALSE
		jr      z, Game7
		ret
Game9	ld      hl, NumberOfBalls
		inc     (hl)
		ld      hl, Level + 1
		call    IncNumberinM
		ld      de, 26 * 256 + 11
		ld      hl, TextLevelComplete
		call    PrintStringB
		ld      b, 50
		call    Delay
		ld      hl, TextLevelComplete
		call    ClearScreenLine
		ld      b, 100
		call    Delay
		jp      Game1
