.text

.eqv keyboard, 0xffff
.eqv display, 0xffff000c
.eqv esc, 27



.macro IsCharacterThere($x, $y)
	lui $x, keyboard 	#look at register 0xFFFF0000
	lw $t1, 0($x)  	#get control
	and $y, $t1, 1 	#determines whether there is a character in the input
.end_macro

.macro GetCharacter($x, $y)
	li $y, 0
	
	GetCharacterLoop:
		IsCharacterThere($x, $y)                                                         #determines whether character is there
		beq $y, $0, GetCharacterLoop                                             #if no data, try later

	#char in 0xFFFF0004
	lui $x, keyboard                                                               #loading address
	lw $y, 4($x)                                                             #loading next word
.end_macro
