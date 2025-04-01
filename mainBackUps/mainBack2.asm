.include "macros.asm"
.include "keyboard.asm"
.include "upWait.asm"

.text
.globl main
.eqv esc, 27
.eqv timer, 1000000

main:
    printStr(hello)
    li $s7, timer

run:
    #change floors
    addi $s7, $s7, -1
    ## beqz $s7, changeFloors

    # Reading keyboard input
    li $t0, 0
    GetCharacter($t0, $v0)
    move $t0, $v0

    li $t3, '1'
    li $t4, '8'
    li $t5, '4'
    li $t6, 'q'

    beqz $t0, Skip
    beq $t0, $t6, emergency
    blt $t0, $t3, Skip
    blt $t4, $t0, Skip

    blt $t5, $t0, addDown
    li $t2, 0
    addQueue(upQueue, $t0, sizeUp, $t2)
    b Skip

    addDown:
    li $t2, 1
    addi $t0, $t0, -4
    addQueue(downQueue, $t0, sizeDown, $t2)

    lw $s2, direction($0)

    j Skip

	changeFloors:
    li $s7, timer
    lw $a0, floor($0)
    lw $a1, direction($0)
    jal floorManager
    printStr(currentfloor)
    lw $t3, floor($0)
    printNum($t3)
    printStr(newLine)
    lw $t3, direction($0)

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
    lw $t5, floor($0)

    beqz $t5, stopped

    lw $t9, direction($0)
    beqz $t9, goUp

    goDown:
        la $a2, downQueue
        sub $a2, $a2, $t5
        neg $a2, $a2
        jal getfloorDown
        sw $v0, floor($0)
        lw $t8, sizeDown($0)
        beqz $t8, changeDirectionUp
        j endFloorManager

    goUp:
        la $a2, upQueue
        add $a2, $a2, $t5
        jal getfloorUP
        sw $v0, floor($0)
        lw $t7, sizeUp($0)
        beqz $t7, changeDirectionDown
        j endFloorManager

    changeDirectionUp:
        li $t9, 0
        sw $t9, direction($0)
        j goUp

    changeDirectionDown:
        li $t9, 1
        sw $t9, direction($0)
        j goDown

    stopped:
        bgt $t7, $t8, startUp
        beq $t7, $t8, startUp

        li $t9, 1
        sw $t9, direction($0)
        j endFloorManager

    startUp:
        li $t9, 0
        sw $t9, direction($0)
        j endFloorManager

endFloorManager:
    jr $ra

getfloorUP:
    la $t4, upQueue
    li $t1, 4
    mul $t1, $t1, $t6
    add $t4, $t4, $t1

    checkFloor:
        beq $t4, $a2, exitGet
        lw $v0, 0($a2)
        addi $a2, $a2, 4
        beqz $v0, checkFloor

        addi $a2, $a2, -4
        sw $0, 0($a2)
        lw $t3, sizeUp($0)
        addi $t3, $t3, -1
        sw $t3, sizeUp($0)
        move $v0, $a2
        addi $v0, $v0, 4
        lw $v0, 0($v0)
        jr $ra

    exitGet:
        jr $ra

getfloorDown:
    la $t4, downQueue

    checkFloorD:
        blt $t4, $a2, exitGetD
        lw $v0, 0($a2)
        addi $a2, $a2, -4
        beqz $v0, checkFloorD

        addi $a2, $a2, 4
        sw $0, 0($a2)
        lw $t3, sizeDown($0)
        addi $t3, $t3, -1
        sw $t3, sizeDown($0)
        move $v0, $a2
        subi $v0, $v0, 4
        lw $v0, 0($v0)
        jr $ra

    exitGetD:
        jr $ra

.data
hello: .asciiz "Program running...\n"
newLine: .asciiz "\n"

upQueue: .word 0, 0, 0, 0
.space 20

downQueue: .word 0, 0, 0, 0
.space 20

sizeUp: .word 0
sizeDown: .word 0

direction: .word 0
floor: .word 0

emergencyPressed: .asciiz "\nThe emergency button was pressed\nStay calm...Help is on the way\n\n"
systemReset: .asciiz "System resetting: [          ]\n"
complete: .asciiz "\nSystem's back online... [*]-[*]\n\n"

currentfloor: .asciiz "current floor -> "
dirUp: .asciiz "Going up...\n"
dirDown: .asciiz "Going down...\n"
