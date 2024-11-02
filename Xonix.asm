; Xonix V 0.2
                    DEVICE  ZXSPECTRUM48

LAST_KEY            equ	    23560
EMPTY               equ	    0
LAND                equ	    1
TLAND               equ	    2
BALL                equ	    3
ENEMY               equ	    4
HEADPL              equ	    5
TRACE               equ     6
offsetX             equ	    0
offsetY             equ	    1
offsetDX            equ	    2
offsetDY            equ	    3
offsetEasy          equ     5
offsetOldX          equ     6
offsetOldY          equ     7
FIELDWIDTH          equ     64
FIELDHEIGHT         equ     46
VSON                equ     $C0
VSOFF               equ     $00
STACKPOINTER        equ     $c7ff
TRUE                equ     1
FALSE               equ     0
ADRVIRTSCREEN       equ     $8000

 
    org     25000

Start:
    ld      sp, STACKPOINTER

Start1:
    call    Menu
    call    Game
    ld      de, 26 * 256 + 11
    ld      hl, TextGameOver
    call    PrintStringB
    ld      b, 50
    call    Delay
    ld      hl, TextGameOver
    call    ClearScreenLine
    ld      b, 100
    call    Delay
    jr      Start1

    include "Menu.asm"
    include "Game.asm"
    include "Player.asm"
    include "Ball.asm"
    include "Enemy.asm"
    include "SpriteSubs.asm"
    include "FieldSubs.asm"
    include "StringSubs.asm"
    include "Subs.asm"

TextTitle           defb    "PRESS ANY KEY", 0
TextGameOver        defb    "GAME  OVER", 0
TextLevelComplete   defb    "LEVEL COMPLETE", 0
TextScore           defb    "SCORE:", 0
TextFull            defb    "FULL:", 0
TextLevel           defb    "LEVEL:", 0
TextLevel2          defb    "LEVEL 00", 0
TextLives           defb    "LIVES:", 0
TextTime            defb    "TIME:", 0
EmptyString         defb    0
SpriteLand          defb    %00000000
                    defb    %01100110
                    defb    %01100110
                    defb    %00000000
SpriteTrace         defb    %00000000
                    defb    %01000000
                    defb    %00000100
                    defb    %00000000
SpriteBall          defb    %01100110
                    defb    %11011101
                    defb    %10011001
                    defb    %01100110
SpritePlayer        defb    %11111111
                    defb    %11111111
                    defb    %11111111
                    defb    %11111111
Time                defb    $30, $30, $30, $30, $30, $30, 0
Full                defb    $30, $30, '%', 0
Score               defb    $30, $30, $30, $30, $30, $30, 0
Lives               defb    $30, $30, 0
Level               defb    $30, $31, 0
tFull               defw    0
varTraceExists      defb    0
EndOfGame           defb    0
VirtualScreenOnOFF  defb    0
Rand1:              defb    0xaa				; random numbers
Rand2:              defb    0x55
Rand3:              defb    0xf0
PlayerVariables     dup     7
                    defb    0
                    edup
FieldArray          dup     FIELDWIDTH * FIELDHEIGHT
                    defb    0
                    edup
NumberOfBalls       defb    0
NumberOfEnemies     defb    0
BallArray           dup     4 * 20   ; an array of enemies that move across the sea
                    defb    0
                    edup
EnemyArray          dup     4 * 20   ; an array of enemies that move over land
                    defb    0
                    edup
sprite_title	    defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                    defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                    defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                    defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                    defb $03, $C0, $00, $00, $03, $C0, $00, $00, $FF, $00, $00, $03, $C0, $00, $00, $03, $C0, $3C, $03, $C0, $00, $00, $03, $C0
                    defb $07, $E0, $00, $00, $07, $E0, $00, $0F, $FF, $F0, $00, $07, $E0, $00, $00, $07, $E0, $7E, $07, $E0, $00, $00, $07, $E0
                    defb $0F, $F0, $00, $00, $0F, $F0, $00, $3F, $FF, $FC, $00, $0F, $F0, $00, $00, $0F, $F0, $FF, $0F, $F0, $00, $00, $0F, $F0
                    defb $0F, $F8, $00, $00, $1F, $F0, $00, $7F, $FF, $FE, $00, $0F, $F8, $00, $00, $0F, $F0, $FF, $0F, $F8, $00, $00, $1F, $F0
                    defb $0F, $FC, $00, $00, $3F, $F0, $00, $FF, $FF, $FF, $00, $0F, $FC, $00, $00, $0F, $F0, $FF, $0F, $FC, $00, $00, $3F, $F0
                    defb $0F, $FE, $00, $00, $7F, $F0, $01, $FF, $FF, $FF, $80, $0F, $FE, $00, $00, $0F, $F0, $FF, $0F, $FE, $00, $00, $7F, $F0
                    defb $07, $FF, $00, $00, $FF, $E0, $03, $FF, $FF, $FF, $C0, $0F, $FF, $00, $00, $0F, $F0, $FF, $07, $FF, $00, $00, $FF, $E0
                    defb $03, $FF, $80, $01, $FF, $C0, $07, $FF, $FF, $FF, $E0, $0F, $FF, $80, $00, $0F, $F0, $FF, $03, $FF, $80, $01, $FF, $C0
                    defb $01, $FF, $C0, $03, $FF, $80, $0F, $FF, $87, $FF, $F0, $0F, $FF, $C0, $00, $0F, $F0, $FF, $01, $FF, $C0, $03, $FF, $80
                    defb $00, $FF, $E0, $07, $FF, $00, $1F, $FC, $00, $FF, $F8, $0F, $FF, $E0, $00, $0F, $F0, $FF, $00, $FF, $E0, $07, $FF, $00
                    defb $00, $7F, $F0, $0F, $FE, $00, $3F, $F0, $00, $3F, $FC, $0F, $FF, $F0, $00, $0F, $F0, $FF, $00, $7F, $F0, $0F, $FE, $00
                    defb $00, $3F, $F8, $1F, $FC, $00, $3F, $E0, $00, $1F, $FC, $0F, $FF, $F8, $00, $0F, $F0, $FF, $00, $3F, $F8, $1F, $FC, $00
                    defb $00, $1F, $FC, $3F, $F8, $00, $7F, $C0, $00, $0F, $FE, $0F, $FF, $FC, $00, $0F, $F0, $FF, $00, $1F, $FC, $3F, $F8, $00
                    defb $00, $0F, $FE, $7F, $F0, $00, $7F, $C0, $00, $0F, $FE, $0F, $FF, $FE, $00, $0F, $F0, $FF, $00, $0F, $FE, $7F, $F0, $00
                    defb $00, $07, $FF, $FF, $E0, $00, $7F, $80, $00, $07, $FE, $0F, $F7, $FF, $00, $0F, $F0, $FF, $00, $07, $FF, $FF, $E0, $00
                    defb $00, $03, $FF, $FF, $C0, $00, $7F, $80, $00, $07, $FE, $0F, $F3, $FF, $80, $0F, $F0, $FF, $00, $03, $FF, $FF, $C0, $00
                    defb $00, $01, $FF, $FF, $80, $00, $FF, $00, $00, $03, $FF, $0F, $F1, $FF, $C0, $0F, $F0, $FF, $00, $01, $FF, $FF, $80, $00
                    defb $00, $00, $FF, $FF, $00, $00, $FF, $00, $00, $03, $FF, $0F, $F0, $FF, $E0, $0F, $F0, $FF, $00, $00, $FF, $FF, $00, $00
                    defb $00, $00, $7F, $FE, $00, $00, $FF, $00, $00, $03, $FF, $0F, $F0, $7F, $F0, $0F, $F0, $FF, $00, $00, $7F, $FE, $00, $00
                    defb $00, $00, $3F, $FC, $00, $00, $FF, $00, $00, $03, $FF, $0F, $F0, $3F, $F8, $0F, $F0, $FF, $00, $00, $3F, $FC, $00, $00
                    defb $00, $00, $3F, $FC, $00, $00, $FF, $00, $00, $03, $FF, $0F, $F0, $1F, $FC, $0F, $F0, $FF, $00, $00, $3F, $FC, $00, $00
                    defb $00, $00, $7F, $FE, $00, $00, $FF, $00, $00, $03, $FF, $0F, $F0, $0F, $FE, $0F, $F0, $FF, $00, $00, $7F, $FE, $00, $00
                    defb $00, $00, $FF, $FF, $00, $00, $FF, $80, $00, $07, $FF, $0F, $F0, $07, $FF, $0F, $F0, $FF, $00, $00, $FF, $FF, $00, $00
                    defb $00, $01, $FF, $FF, $80, $00, $FF, $80, $00, $07, $FF, $0F, $F0, $03, $FF, $8F, $F0, $FF, $00, $01, $FF, $FF, $80, $00
                    defb $00, $03, $FF, $FF, $C0, $00, $7F, $C0, $00, $0F, $FE, $0F, $F0, $01, $FF, $CF, $F0, $FF, $00, $03, $FF, $FF, $C0, $00
                    defb $00, $07, $FF, $FF, $E0, $00, $7F, $C0, $00, $0F, $FE, $0F, $F0, $00, $FF, $EF, $F0, $FF, $00, $07, $FF, $FF, $E0, $00
                    defb $00, $0F, $FE, $7F, $F0, $00, $7F, $E0, $00, $1F, $FE, $0F, $F0, $00, $7F, $FF, $F0, $FF, $00, $0F, $FE, $7F, $F0, $00
                    defb $00, $1F, $FC, $3F, $F8, $00, $7F, $F0, $00, $3F, $FE, $0F, $F0, $00, $3F, $FF, $F0, $FF, $00, $1F, $FC, $3F, $F8, $00
                    defb $00, $3F, $F8, $1F, $FC, $00, $3F, $FC, $00, $FF, $FC, $0F, $F0, $00, $1F, $FF, $F0, $FF, $00, $3F, $F8, $1F, $FC, $00
                    defb $00, $7F, $F0, $0F, $FE, $00, $3F, $FF, $87, $FF, $FC, $0F, $F0, $00, $0F, $FF, $F0, $FF, $00, $7F, $F0, $0F, $FE, $00
                    defb $00, $FF, $E0, $07, $FF, $00, $1F, $FF, $FF, $FF, $F8, $0F, $F0, $00, $07, $FF, $F0, $FF, $00, $FF, $E0, $07, $FF, $00
                    defb $01, $FF, $C0, $03, $FF, $80, $0F, $FF, $FF, $FF, $F0, $0F, $F0, $00, $03, $FF, $F0, $FF, $01, $FF, $C0, $03, $FF, $80
                    defb $03, $FF, $80, $01, $FF, $C0, $07, $FF, $FF, $FF, $E0, $0F, $F0, $00, $01, $FF, $F0, $FF, $03, $FF, $80, $01, $FF, $C0
                    defb $07, $FF, $00, $00, $FF, $E0, $03, $FF, $FF, $FF, $C0, $0F, $F0, $00, $00, $FF, $F0, $FF, $07, $FF, $00, $00, $FF, $E0
                    defb $0F, $FE, $00, $00, $7F, $F0, $01, $FF, $FF, $FF, $80, $0F, $F0, $00, $00, $7F, $F0, $FF, $0F, $FE, $00, $00, $7F, $F0
                    defb $0F, $FC, $00, $00, $3F, $F0, $00, $FF, $FF, $FF, $00, $0F, $F0, $00, $00, $3F, $F0, $FF, $0F, $FC, $00, $00, $3F, $F0
                    defb $0F, $F8, $00, $00, $1F, $F0, $00, $7F, $FF, $FE, $00, $0F, $F0, $00, $00, $1F, $F0, $FF, $0F, $F8, $00, $00, $1F, $F0
                    defb $0F, $F0, $00, $00, $0F, $F0, $00, $3F, $FF, $FC, $00, $0F, $F0, $00, $00, $0F, $F0, $FF, $0F, $F0, $00, $00, $0F, $F0
                    defb $07, $E0, $00, $00, $07, $E0, $00, $0F, $FF, $F0, $00, $07, $E0, $00, $00, $07, $E0, $7E, $07, $E0, $00, $00, $07, $E0
                    defb $03, $C0, $00, $00, $03, $C0, $00, $00, $FF, $00, $00, $03, $C0, $00, $00, $03, $C0, $3C, $03, $C0, $00, $00, $03, $C0
                    defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                    defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                    defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                    defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

                    include "font8x4.asm"

                    org	    $fe00
y_lookup4
                    defb   $00, $00, $20, $20, $40, $40, $60, $60
                    defb   $80, $80, $A0, $A0, $C0, $C0, $E0, $E0
                    defb   $00, $00, $20, $20, $40, $40, $60, $60
                    defb   $80, $80, $A0, $A0, $C0, $C0, $E0, $E0
                    defb   $00, $00, $20, $20, $40, $40, $60, $60
                    defb   $80, $80, $A0, $A0, $C0, $C0, $E0, $E0

                    org	    $ff00
y_lookup42
                    defb   $40, $44, $40, $44, $40, $44, $40, $44
                    defb   $40, $44, $40, $44, $40, $44, $40, $44
                    defb   $48, $4C, $48, $4C, $48, $4C, $48, $4C
                    defb   $48, $4C, $48, $4C, $48, $4C, $48, $4C
                    defb   $50, $54, $50, $54, $50, $54, $50, $54
                    defb   $50, $54, $50, $54, $50, $54, $50, $54

                    SAVESNA "xonix.sna", Start
