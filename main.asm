.include "macros.asm"
.include "keyboard.asm"
.include "upWait.asm"

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
	
	li $t3, '1'
	li $t4, '8'
	li $t5, '4'
	
	# Ignore unwanted inputs
	blt $t0, $t3, Skip
	blt $t4, $t0, Skip
	
	blt $t5, $t0, goDown
	# Going up
	addToUnsorted(upUnsorted, sizeUpUnsort)
	b Skip
	
	goDown:
	addToUnsorted(downUnsorted, sizeDownUnsort)
	
	Skip:
	li $t1, esc
	bne $t0, $t1, run


	
	
endMain:
exit()

.data
hello: .asciiz "Program running...\n"
newLine: .asciiz "\n"

upSorted: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0		# stores floor (1-5 up, 6-9 down)
.space 36 			# queue = array of size 9

upUnsorted: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0		# stores floor (1-5 up, 6-9 down)

downSorted: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0		# stores floor (1-5 up, 6-9 down)
.space 36 			# queue = array of size 9

downUnsorted: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0		# stores floor (1-5 up, 6-9 down)
.space 36 			# queue = array of size 9

sizeUpSort: .word 0 	# current quesize 
sizeUpUnsort: .word 0 	# current quesize 
sizeDownSort: .word 0 	# current quesize 
sizeDownUnsort: .word 0 	# current quesize 


ptrQueue: .word 0	# first element
floor: .byte 		# current floor
