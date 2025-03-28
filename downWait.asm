.data
#Dummy queue for testing
#queue: .word 10, 0, 0, 0, 0, 0, 0, 0, 0, 0
maxReached: .asciiz "Max size has been reached. Cannot accept more input."
#Prompt for printing queue
#test: .asciiz "\nElement: "
.text
#Loading dummy queue into $a0 for testing
#la $a0, queue

#Dummy loop and sample input for testing code
#dummyLoop:
#li $a1, 7

#Input(values 6-9) = $a1, Address of array/queue = $a0
downWait:
	li $s0, 0 #Initialize i = 0

#Loop until we find an empty spot to insert (aka if value is 0) OR if we reach the max size (10)
loop1:
	slti $t0, $s0, 10			#Shift if i < 10
	beq $t0, $zero, maxSizeReached		#Branch if i >= 10
	sll $t1, $s0, 2 			#i * 4 (offset for array)
	add $t2, $a0, $t1 			#Increase array pointer by offset
	lw $t3, 0($t2) 				#load array[i]
	beqz $t3, enqueue			#if array[i]= 0, insert input here
	addi $s0, $s0, 1			#i += 1
	j loop1

#If max size is reached, exit
maxSizeReached:
	#jal printQueue
	li $v0, 4
	la $a0, maxReached
	syscall
	j exit2

#Insert input
enqueue:
	sw $a1, 0($t2) #Store input in array[i]
	#jal printQueue
	j exit2

#Restart dummy loop
#exit:
#	j dummyLoop
	
#Exit program
exit2:
	li $v0, 10
	syscall

#Print array/queue for testing
#printQueue:
#	li $s0, 0 #initialize i = 0
#	move $s5, $a0
#	loop2:
#	slti $t0, $s0, 10
#	beq $t0, $zero, exit
#	sll $t1, $s0, 2
#	add $t2, $s5, $t1
#	lw $t3, 0($t2)
#	li $v0, 4
#	la $a0, test
#	syscall
#	li $v0, 1
#	move $a0, $t3
#	syscall
#	addi $s0, $s0, 1
#	j loop2