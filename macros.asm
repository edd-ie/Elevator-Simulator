.macro printNum($x)
	#li $a0, %x   # loads a immediate
	la $a0, ($x)	  # loads an address
	li $v0, 1
	syscall
	printStr(newLine)
.end_macro

.macro printStr(%str)
    la $a0, %str		# Load the address of the string into $a0
    li $v0, 4 		# Load the system call code for print_string into $v0
    syscall
.end_macro

.macro push %rx
    addi $sp, $sp ,-4
    sw %rx ,0($sp)
.end_macro

.macro pop %rx
    lw %rx, 0($sp)
    addi $sp, $sp ,4
.end_macro



.macro peek %rx
	la $t0, queue
	la $t1, ptrQueue
	lw $t2, 0($t1)
	add $t2, $t0, $t2
	lw %rx 0($t2)
.end_macro

.macro exit
	# Exit the program
    li $v0, 10
    syscall
.end_macro