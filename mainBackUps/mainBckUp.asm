.include "macros.asm"
.include "keyboard.asm"
.include "upWait.asm"

.text
.globl main
.eqv esc, 27
.eqv timer, 1000000

main: 
	printStr(hello)
	reset(upQueue, sizeUp)
	reset(downQueue,sizeDown)
	li $s7, timer
	
run:
	#change floors
	addi $s7 $s7,-1
	beqz $s7, changeFloors
	
	
	# Reading keyboard input
	li $t0, 0                                  #initialize character to zero
	GetCharacter($t0, $v0)                     #wait for user to enter in character	
	
	move $t0, $v0                              #store character in $t0	
	
	li $t3, '1'
	li $t4, '8'
	li $t5, '4'
	li $t6, 'q'
	
	
    
	# Ignore unwanted inputs
	beqz $t0, Skip
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
	
	j Skip
	
	changeFloors:
		li $s7, timer
		lw $a0, floor($0)
		lw $a1, direction($0)
		jal floorManager
		printStr(currentfloor)
		lw $t3, direction($0)
		printNum($t3)		
		
		beqz $t3, prntUp
		printStr(dirDown)
		b Skip
		prntUp:
		printStr(dirUp)
		b Skip
		
	
	
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
	li $t6, 4
	lw $t7, sizeUp($0)
	lw $t8, sizeDown($0)
	
	beqz $a0, stopped
	
	#moving floors
	lw $t5, floor($0)
	beqz $a1, goUp
	
	goDown:
	la $a2, downQueue
	add $a2, $t5, $a2
	jal getfloorDown	
	sw $v0, floor($0)
	add $t4, $t8, $v0
	beqz $t4 stopMoving
	beq $t4, $t7, goUp
	j endFloorManager
	
	goUp:
	la $a2, upQueue
	add $a2, $t5, $a2
	jal getfloorUP
	sw $v0, floor($0)
	
	add $t4, $t8, $v0
	beqz $t4 stopMoving
	beq $t4, $t8, goDown
	j endFloorManager
	
	stopMoving:
	sw $0, direction($0)
	sw $0, floor($0)
	reset(upQueue, sizeUp)
	reset(downQueue,sizeDown)
	j endFloorManager
	
	stopped:
	blt $t7, $t8, startDown
	startUp:
		sw $0, direction($0)
	
	
	startDown:
		li $t9, 1
		sw $t9, direction($0)
	

endFloorManager:
jr $ra


getfloorUP:
	la $t4, upQueue
	addi $t4, $t4, 16
	
	checkFloor:
	beq $t4, $a2, exitGet
	lw $v0 0($a2)
	addi $a2, $a2, 4
	beqz $v0 checkFloor
	
	addi $a2, $a2, -4
	sw $0 0($a2)
	lw $t4, sizeUp($0)
	addi $t4, $t4, -1
	sw $t4, sizeUp($0)
exitGet:
jr $ra

getfloorDown:
	la $t4, downQueue
	
	checkFloorD:
	blt $t4, $a2, exitGetD
	lw $v0 0($a2)
	addi $a2, $a2, -4
	beqz $v0 checkFloorD
	
	addi $a2, $a2, 4
	sw $0 0($a2)
	lw $t4, sizeDown($0)
	addi $t4, $t4, -1
	sw $t4, sizeDown($0)
	
exitGetD:
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

direction: .word 0  # 0 = up, 1 = down
floor: .word 0 		# current floor"

emergencyPressed: .asciiz "\nThe emergency button was pressed\nStay calm...Help is on the way\n\n"
systemReset: .asciiz "System resetting: [                    ]\n"
complete: "\nSystem's back online... [*]-[*]\n\n"

currentfloor: .asciiz "current floor -> "
dirUp:  .asciiz "Going up...\n"
dirDown:  .asciiz "Going down...\n"