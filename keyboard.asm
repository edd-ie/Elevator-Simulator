.include "macros.asm"

.text

.eqv keyboard, 0xffff
.eqv display, 0xffff000c
.eqv esc, 27


main:
	li $t0, 0                                                                      #initialize character to zero
	jal GetCharacter                                                               #wait for user to enter in character

	move $t0, $v0                                                                 #store character in $t0

	li $v0, 11                                                                      #syscall for print character
	move $a0, $t0                                                                 #pass in $t0 as argument $a0
	syscall #print character
	
	li $t1, esc
	bne $t0, $t1, main

	li $v0, 10                                                                      #syscall for exit program
	syscall #exit program

#Is Character There
#procedure to determine whether a character is present
#return - $v0 = 0 (no data), $v0 = 1 (character is in the buffer)
IsCharacterThere:
	lui $t0, keyboard 	#look at register 0xFFFF0000
	lw $t1, 0($t0)  	#get control
	and $v0, $t1, 1 	#determines whether there is a character in the input
	jr $ra           	#return

#Get Character
#procedure to poll the keypad and wait for an input character
#return - $v0 - ASCII character
GetCharacter:
	push $ra		#store return address in stack
	li $v0, 0                                                                      #clear $v0
	
	j CharacterCheck
	
	GetCharacterLoop:
		jal IsCharacterThere                                                        #determines whether character is there
	CharacterCheck:
		beq $v0, $0, GetCharacterLoop                                             #if no data, try later
	
	#char in 0xFFFF0004
	lui $t0, keyboard                                                               #loading address
	lw $v0, 4($t0)                                                                #loading next word
	
	pop $ra		#readjust stack pointer
	jr $ra                                                                        #return