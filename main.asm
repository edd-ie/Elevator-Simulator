.include "macros.asm"

.text
.globl main


main: 
	printStr(hello)
	printStr(newLine)
	
	# avoid using t0-t3
	addi $t4, $0, 100
	printNum($t4)
	
	push $t4
	pop $t5
	printNum($t5)
	
	peek $t4
	printNum($t4)

endMain:
exit

.data
hello: .asciiz "Program running..."
newLine: .asciiz "\n"
queue: .word 0		# stores floor (1-5 up, 6-9 down)
.space 36 			# queue = array of size 9
sizeQueue: .byte 0 	# current quesize 
ptrQueue: .word 0	# first element
floor: .byte 		# current floor