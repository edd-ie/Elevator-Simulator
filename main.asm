.include "macros.asm"
.include "keyboard.asm"
.include "upWait.asm"

.text
.globl main
.eqv esc, 27


main: 
	printStr(hello)
	reset(upUnsorted, sizeUpUnsort)
	reset(downUnsorted,sizeDownUnsort)
	
run:

	# Reading keyboard input
	li $t0, 0                                  #initialize character to zero
	GetCharacter($t0, $v0)                     #wait for user to enter in character	
	
	move $t0, $v0                              #store character in $t0	
	
	li $t3, '1'
	li $t4, '8'
	li $t5, '4'
	li $t6, 'q'
	
	
    
	# Ignore unwanted inputs
	beq $t0, $t6, emergency
	blt $t0, $t3, Skip
	blt $t4, $t0, Skip
	
	blt $t5, $t0, addDown
	# Going up
	li $t2, 0
	addQueue(upUnsorted, $t0, sizeUpUnsort, $t2)
	b Skip
	
	addDown:
	li $t2, 1
	addi $t0, $t0, -4
	addQueue(downUnsorted, $t0, sizeDownUnsort, $t2)
	
	lw $s2, direction($0)	# get movement direction
	
	
	
	goUP:
	
	goDown:
	
	j Skip
	
	emergency:
		reset(upUnsorted, sizeUpUnsort)
		reset(downUnsorted,sizeDownUnsort)
		animation(emergencyPressed, systemReset)
		printStr(complete)
	
	Skip:
	li $t1, esc
	bne $t0, $t1, run

	
	
endMain:
exit()






timeD:
	li $v0, 30          # Load the syscall code for 'time' into $v0
    syscall             # Perform the syscall
	
	move $s1, $a0
	li $t3, 1000
	divu $s1, $s1, $t3
    # Print the message
    printStr(time)
	
	printNum($s1)
	
	
	###3
	
	
	printStr(hello)
	li $v0, 30          # Load the syscall code for 'time' into $v0
    syscall             # Perform the syscall
	
	move $s2, $a0
	li $t3, 1000
	divu $s2, $s2, $t3
    # Print the message
    printStr(time)
	
	sub $s2, $s2, $s1
	printNum($s2)
	
jr $ra
	

.data
hello: .asciiz "Program running...\n"
newLine: .asciiz "\n"

upSorted: .word 0,0,0,0		# stores floor (1-5 up, 6-9 down)
.space 20 			# queue = array of size 9

upUnsorted: .word 0,0,0,0		# stores floor (1-5 up, 6-9 down)
.space 20

downSorted: .word 0,0,0,0	# stores floor (1-4 up, 5-8 down)
.space 20 			# queue = array of size 9

downUnsorted: .word 0, 0, 0, 0		# stores floor (1-5 up, 6-9 down)
.space 20 			# queue = array of size 9

sizeUpSort: .word 0 	# current quesize 
sizeUpUnsort: .word 0 	# current quesize 
sizeDownSort: .word 0 	# current quesize 
sizeDownUnsort: .word 0 	# current quesize 

direction: .word 0  # 0 = up, 1 = down
floor: .word 0 		# current floor
time: .asciiz "Current time: "

emergencyPressed: .asciiz "\nThe emergency button was pressed\nStay calm...Help is on the way\n\n"
systemReset: .asciiz "System resetting: [                    ]\n"
complete: "\nSystem's back online... [*]-[*]\n\n"