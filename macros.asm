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

.macro print($x)
	li $v0, 11                                                                      #syscall for print character
	move $a0, $x                                                                #pass in $t0 as argument $a0
	syscall #print character
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

.macro exit()
	# Exit the program
    li $v0, 10
    syscall
.end_macro

.macro animation(%emergencyPressed, %systemReset)
    # Print emergency message
    printStr(%emergencyPressed)

    # Initialize loading bar
    printStr(%systemReset)

    # Loading bar animation
    li $s2, 0          # Counter for loading bar
    li $s3, 20         # Length of loading bar
    li $s4, '='        # Character to fill the loading bar

load_loop:
    # Print loading bar progress
    printStr(%systemReset)

    # Update loading bar
    la $t2, %systemReset
    addi $t2, $t2, 19  # Position to start filling the bar
    add $t2, $t2, $s2  # Move to the next position
    sb $s4, 0($t2)     # Fill with '=' character

    # Increment counter
    addi $s2, $s2, 1

    # Delay for animation effect using a loop
    li $t4, 20000     # Set delay counter
	delay_loop:
    	subi $t4, $t4, 1
    	bnez $t4, delay_loop

  	# Check if loading bar is complete
    bne $s2, $s3, load_loop

    # Print completion message
    printStr(%systemReset)
    
    # Loading bar animation
    li $s2, 0          # Counter for loading bar
    li $s3, 20         # Length of loading bar
    li $s4, ' '        # Character to fill the loading bar
    
    # Update loading bar
    la $t2, %systemReset
    addi $t2, $t2, 19  # Position to start filling the bar
    
	clear_loop:
    
    add $t5, $t2, $s2  # Move to the next position
    sb $s4, 0($t5)     # Fill with ' ' character

    # Increment counter
    addi $s2, $s2, 1

    # Check if loading bar is complete
    bne $s2, $s3, clear_loop
.end_macro