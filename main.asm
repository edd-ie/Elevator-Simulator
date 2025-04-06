.include "macros.asm"
.include "keyboard.asm"
.include "queue.asm"

################################################################
# Setup
################################################################
# Click tools
# Select keyboard and display MMIO Simulator
# At bottom Click connect to MIPS
# Compile the code
# Set run speed at top right = 30inst/sec
# Run program

################################################################
# Key bindings
################################################################
# 1-4 = floor requests, moving up
# 5-8 = floor requests, moving down (5 = floor 1, 8 = floor 4)
# q = Emergency alert
# esc = Exit the program
################################################################

.text
.globl main
.eqv esc, 27
.eqv clk, 6


main: 
	li $s6, clk

	printStr(hello)
	reset(upQueue, sizeUp)
	reset(downQueue,sizeDown)
	
run:
	addi $s6, $s6, -1
    bnez $s6, continue		
    jal floorManager
    li $s6, clk
	
	continue:
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
	lw $s2, direction($0)	# get movement direction
	
	blt $t5, $t0, addDown
	
	#beq $t2, 1, insertDown 	# if currently moving down add to downQueue
	addUp:
		li $t2, 0
		addQueue(upQueue, $t0, sizeUp, $t2)
	b Skip
	
	
	addDown:		
		addi $t0, $t0, -4 	# number - 4 = floor level
		#beq $t2, 2, addUp	# if currently moving down add to upQueue
		insertDown:
		li $t3, 1
		addQueue(downQueue, $t0, sizeDown, $t3)
	b Skip
	
	emergency:
		sw $0, direction($0)
		sw $0, floor($0)
		reset(upQueue, sizeUp)
		reset(downQueue,sizeDown)
		animation(emergencyPressed, systemReset)
		printStr(complete)
	
	Skip:
	li $t1, esc
	bne $t0, $t1, run

	
	
endMain:
exit()


## Fix down Logic
floorManager:
	lw $t4, direction($0)	# get current direction
	lw $t5, floor($0)		# get current floor
	lw $t6, sizeUp($0)		# get upQueue size
	lw $t7, sizeDown($0)	# get downQueue size
	li $t2, 5
	li $t3, 0
	
	beq $t4, 1, moveUp
	beq $t4, 2, moveDown
	
	stopped:
		blt $t7, $t6, moveUp
		blt $t6, $t7, moveDown
		beqz $t6, stationary
	
	moveUp:
		addi $t3, $t3, 1		# increase current floor num
		lw $t6, sizeUp($0)		# update upQueue size
		beq $t3, 5, stopped		# reached top floor
		
		la $t8, upQueue
		sll $t9, $t3, 2
		add $t8, $t8, $t9
		lw $t9, 0($t8)			# get current Queue
		beqz $t9, moveUp		# if not selected skip floor
		
		sw $0, 0($t8)			# mark floor as visited
		addi $t6, $t6, -1		# reduce queue size
		sw $t6, sizeUp($0)			
			
		sw $t3, floor($0)		# update current floor
		li $t3, 1
		sw $t3, direction($0)	# update direction
		
		push $ra
			jal doorDelay		# open the doors
		pop $ra
		printStr(trackUp)
	b endManager
	
	
	
	moveDown:
		addi $t2, $t2, -1 		# decrease current floor num
		lw $t7, sizeDown($0)	# update downQueue size
		beqz $t2 stopped		# reached bottom floor
		
		la $t8, downQueue
		sll $t9, $t2, 2
		add $t8, $t8, $t9
		lw $t9, 0($t8)			# get current Queue
		beqz $t9, moveDown		# if not selected skip floor
		
		sw $0, 0($t8)			# mark floor as visited
		addi $t7, $t7, -1		# reduce queue size
		sw $t7, sizeDown($0)			
		
		sw $t2, floor($0)		# update current floor
		li $t3, 2
		sw $t3, direction($0)	# update direction
		
		push $ra
			jal doorDelay		# open the doors
		pop $ra
		printStr(trackDown)
	b endManager	
	
	
	stationary:
		sw $0, floor($0)
		sw $0, direction($0)
		blt $t7, $t6, moveUp
		blt $t6, $t7, moveDown

endManager:
	lw $t8, floor($0)
	printNum($t8)
jr $ra


doorDelay:
	li $t2, 2
	printStr(openDoor)
	
	delay:
		addi $t2, $t2, -1
		bnez $t2 delay
		
	printStr(closeDoor)
endDelay:
jr $ra






.data

sec: .word 6        # Delay in seconds
mSec: .word 1000 # 1000 milliseconds in a second


hello: .asciiz "Program running...\n"
newLine: .asciiz "\n"


upQueue: .word 0,0,0,0			# stores floor (1-5 up, 6-9 down)
.space 20

downQueue: .word 0, 0, 0, 0		# stores floor (1-5 up, 6-9 down)
.space 20 						# queue = array of size 9

sizeUp: .word 0 				# current quesize 
sizeDown: .word 0 				# current quesize 

direction: .word 0  			# 0 = stoped, 1 = up, 2 = down
floor: .word 0 					# current floor 

trackUp: .asciiz "Moving up\nCurrent floor: "
trackDown: .asciiz "Moving down\nCurrent floor: "
trackStop: .asciiz "Elevator Idle\nCurrent floor: "

openDoor: .asciiz "\n\n+========================+\n|    [<] OPENING [>]     |\n+========================+\n"
closeDoor: .asciiz "\n+========================+\n|    [>] CLOSING [<]     |\n+========================+\n\n"

emergencyPressed: .asciiz "\nThe emergency button was pressed\nStay calm...Help is on the way\n\n"
systemReset: .asciiz "System resetting: [                    ]\n"
complete: "\nSystem's back online... [*]-[*]\n\n"


