.include "macros.asm"
.include "keyboard.asm"

.text
.globl main
.eqv esc, 27

main: 
	printStr(hello)
run:
	# Reading keyboard input
	li $t0, 0                                  #initialize character to zero
	GetCharacter($t0, $v0)                     #wait for user to enter in character	
	
	move $t0, $v0                              #store character in $t0	
	
	li $t3, '0'
	li $t4, '9'
	
	blt $t0, $t3, Skip
	blt $t4, $t0, Skip
	print($t0)
	
	Skip:
	li $t1, esc
	bne $t0, $t1, run

	
endMain:
exit()

.data
hello: .asciiz "Program running...\n"
newLine: .asciiz "\n"
queue: .word 0		# stores floor (1-5 up, 6-9 down)
.space 36 			# queue = array of size 9
sizeQueue: .byte 0 	# current quesize 
ptrQueue: .word 0	# first element
floor: .byte 		# current floor
