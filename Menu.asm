Menu	ld		a, VSON
		ld		(VirtualScreenOnOFF), a
		xor     a, a
		out     (254), a
		ld      hl, $9800
		ld      b, 192
		call    ClearMemoryBlock    
		ld      a, $44
		ld      hl, $5b00
		ld      b, 24
		call	ClearMemoryBlock
		ld		hl, sprite_title
		ld		de, $84e4
		ld		b, 48
Menu1	push	bc
		push	de
		ld		bc, 24
		ldir
		pop		de
		call	DownLineDE 
		pop		bc
		djnz	Menu1
		ld		hl, TextTitle
		ld		de, 25 * 256 + 17
		call	PrintString
		call	CopyScreenLineE
Menu2	in		a,(254)
		cpl
		and		$1f
		jr		z, Menu2
		ld		hl, EmptyString
		call	ClearScreenLine
		ret
