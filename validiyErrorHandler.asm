#Contributors: Mohammad Rahman,	Brady Lewis #//LOG: put in names and netids 
#NETID: mzr210000, bal210004

#--DESCRIPTON--
#
# This file checks to see and catch the errors the player
# may input. For example, an invalid move or a invalid input


.data
validDirs: .asciiz "URDL"

.globl CheckDirOut input_check valid_loc


.text

#checks if valid row, column, and direction
#$v0 == 0 if invalid, ==1 if valid.
#$a0 = input string address
input_check:
	lb $t0 ($a0) #usrIn[0] (a-h)
	andi $t0 $t0 95 #convert to uppercase
	beq $t0 81 exit_game #quit if q was entered
	bgt $t0 73 Invalid
	blt $t0 64 Invalid
	
	addi $t0 $t0 -65 #adjust ascii range from 65-72 to 0-7
	move $s0 $t0
	
	lb $t0 1($a0) #load input row
	addi $t0 $t0 -49 #adjust range from 49-54 to 0-5
	bge $t0 7 Invalid
	blt $t0 0 Invalid
	
	move $s1 $t0
	
	lb $t0 2($a0)
	andi $t0 $t0 95 #convert to uppercase
	
	#compare to U and set $s2 to direction as int
	lb $t1 validDirs
	move $s2 $zero
	beq $t0 $t1 CheckDir
	
	#compare to R and set $s2 to direction as int
	lb $t1 validDirs+1
	addi $s2 $s2 1
	beq $t0 $t1 CheckDir
	
	#compare to D and set $s2 to direction as int
	lb $t1 validDirs+2
	addi $s2 $s2 1
	beq $t0 $t1 CheckDir
	
	#compare to L and set $s2 to direction as int
	lb $t1 validDirs+3
	addi $s2 $s2 1
	beq $t0 $t1 CheckDir
	
	j Invalid

#for outer functions	
CheckDirOut:

	move $s0, $a0
	move $s1, $a1
	move $s2, $a2

CheckDir:

	##TODO: check if direction is out of bounds (example: a4l invalid, cannot go left from column 'a'
	seq $t0 $s2 0 #if dir==up and row==0, then invalid
	seq $t1 $s1 0
	add $t0 $t0 $t1
	beq $t0 2 Invalid
	
	seq $t0 $s2 1 #if dir==right and column==7, then invalid
	seq $t1 $s0 7
	add $t0 $t0 $t1
	beq $t0 2 Invalid
	
	seq $t0 $s2 2 #if dir==down and row==5, then invalid
	seq $t1 $s1 5
	add $t0 $t0 $t1
	beq $t0 2 Invalid
	
	seq $t0 $s2 3 #if dir==left and column==0, then invalid
	seq $t1 $s0 0
	add $t0 $t0 $t1
	beq $t0 2 Invalid
	
	
Valid:
	li $v0 1
	jr $ra
	
Invalid:
	li $v0 0
	jr $ra


valid_loc: # location is not already filled
move $t0 $a0
beq $v1 0 valU
beq $v1 1 valR
beq $v1 2 valD
beq $v1 3 valL
valU:
addi $t0 $t0 -16
j valEnd
valR:
addi $t0 $t0 1
j valEnd
valD:
addi $t0 $t0 16
j valEnd
valL:
addi $t0 $t0 -1
valEnd:
lb $t1 board($t0)
seq $v0 $t1 32
jr $ra