.include "macros.asm"
.include "keyboard.asm"
.include "upWait.asm"

.text
.globl main
.eqv esc, 27


main: 
	printStr(hello)
	reset(upQueue, sizeUp)
	reset(downQueue,sizeDown)
	
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
	addQueue(upQueue, $t0, sizeUp, $t2)
	b Skip
	
	addDown:
	li $t2, 1
	addi $t0, $t0, -4
	addQueue(downQueue, $t0, sizeDown, $t2)
	
	lw $s2, direction($0)	# get movement direction
	
	
	
	goUP:
	
	goDown:
	
	j Skip
	
	emergency:
		reset(upQueue, sizeUp)
		reset(downQueue,sizeDown)
		animation(emergencyPressed, systemReset)
		printStr(complete)
	
	Skip:
	li $t1, esc
	bne $t0, $t1, run

	
	
endMain:
exit()



floorManager:
	lw $t0, direction($0)
	lw $t1, sizeUp($0)
	lw $t2, sizeDown($0)
	
	beqz $t0, stopped
	beq $t0, 2, goingDown
	
	
	goingUp:
		lw $t3, floor($0)
		# add if t3 = 4, move down, 
		sll $t3, $t3, 2
		la $t4, upQueue
		add $t4, $t4, $t3

		lw $t5, 0($t4)
		# add if t5 = 0, skip floor
		sw $0, 0($t4)
		sw $t5 floor($0)
		addi $t1, $t1, -1
		sw $t1, sizeUp($0)		
	j endManager
	
	
	goingDown:
		lw $t3, floor($0)
		addi $t3, $t3 -1
		# add if t3 = 0, move up
		sll $t3, $t3, 2
		la $t4, upQueue
		add $t4, $t4, $t3

		lw $t5, 0($t4)
		# add if t5 = 0, skip floor
		sw $0, 0($t4)
		sw $t5 floor($0)
		addi $t1, $t1, -1
		sw $t1, sizeUp($0)
	j endManager
	
	
	stopped:		
		blt $t1, $t2, moveDown
		
		moveUp:
			lw $t3, upQueue($0)
			sw $t0, upQueue($0)
			addi $t3, $t3, 1
			sw $t3, floor($0)
			addi $t1, $t1, -1
			sw $t1, sizeUp($0)
			li $t4, 1
			sw $t4, direction($0)
		j endManager
		
		moveDown:
			la $t3, downQueue
			addi $t4, $t3, 12
			lw $t3, 0($t4)
			sw $t0, 0($t4)
			sw $t3, floor($0)
			addi $t1, $t1, -1
			sw $t1, sizeDown($0)
			li $t4, 2
			sw $t4, direction($0)

endManager:
jr $ra





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


upQueue: .word 0,0,0,0		# stores floor (1-5 up, 6-9 down)
.space 20

downQueue: .word 0, 0, 0, 0		# stores floor (1-5 up, 6-9 down)
.space 20 			# queue = array of size 9

sizeUp: .word 0 	# current quesize 
sizeDown: .word 0 	# current quesize 

direction: .word 0  # 0 = stoped, 1 = up, 2 = down
floor: .word 0 		# current floor
time: .asciiz "Current time: "

emergencyPressed: .asciiz "\nThe emergency button was pressed\nStay calm...Help is on the way\n\n"
systemReset: .asciiz "System resetting: [                    ]\n"
complete: "\nSystem's back online... [*]-[*]\n\n"
