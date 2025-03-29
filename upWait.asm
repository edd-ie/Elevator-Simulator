.macro addQueue(%queue, $value, %queueSize, $signal)
	la $a0, %queue
	move $a1, $value
	addi $a1, $a1, -48
	la $a2, %queueSize
	
	
	beqz $signal, skipAdd	
	upWait(floorDownQueue)
	b exitAddToQueue
	
	skipAdd:
	upWait(floorUpQueue)
	
exitAddToQueue:
.end_macro 

.macro reset(%queue, %queueSize)
	# count = 0
	la $t1, %queueSize	 
	sw $0, 0($t1)
	
	# Queue = []
	li $t0, 16
	la $t1, %queue	
	add $t2, $t1, $t0
	
	erase:
	addi $t1, $t1, 4
	sw $zero, 0($t1)
	bne $t1, $t2, erase
	
.end_macro 

#Input(values 1-5) = $a1, Address of array/queue = $a0
.macro upWait(%floor)
	li $s0, 0 #Initialize i = 0

#Loop until we find an empty spot to insert (aka if value is 0) OR if we reach the max size (10)
loop1:
	location:
	sll $t1, $a1, 2
	add $t3, $a0, $t1 	# array[value]
	
	
	
	checkData:
	lw $t2, 0($t3)
	beq $t2, $a1, exists


#Insert input
enqueue:
	#Store input in array[i]
	sw $a1, 0($t3)
	addi $a1, $a1, 48
	print($a1)
	printStr(%floor)
	
	# Increase array counter
	lw $t2, 0($a2)
	addi $t2, $t2, 1
	sw $t2, 0($a2)
	
	li $v1, 1
	j exit2

exists:
	printStr(alreadyPressed)
	li $v1, 0
	j exit2
#Restart dummy loop
#exit:
#	j dummyLoop
	
#Exit program
exit2:
.end_macro

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


.data
#Dummy queue for testing
#queue: .word 10, 0, 0, 0, 0, 0, 0, 0, 0, 0
maxReached: .asciiz "Floor queue filled. Cannot accept more input.\n"
alreadyPressed: .asciiz "Floor already pressed!\n"
floorUpQueue: .asciiz " floor - Up\n"
floorDownQueue: .asciiz " floor - Down\n"
