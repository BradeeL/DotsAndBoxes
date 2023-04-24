#Contributors: Mohammad Rahman,	Brady Lewis #//LOG: put in names and netids 
#NETID: mzr210000, bal210004

#--DESCRIPTON--
#
# This file checks to see and catch the errors the player
# may input. For example, an invalid move or a invalid input


.data
validDirs: .asciiz "URDL"

.globl valid_loc
.globl input_check

.text

#checks if valid row, column, and direction
#$v0 == 0 if invalid, ==1 if valid.
#$a0 = input string address
input_check:
	lb $t0 ($a0) #usrIn[0] (a-h)
	andi $t0 $t0 95 #convert to uppercase
	bge $t0 73 Invalid
	ble $t0 64 Invalid
	
	addi $t0 $t0 -64#adjust ascii range from 65-72 to 1-8
	move $s0 $t0
	
	lb $t0 1($a0)#load input row
	addi $t0 $t0 -48#adjust range from 49-54 to 1-6
	bge $t0 7 Invalid
	ble $t0 0 Invalid
	
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
	
	
CheckDir:
	##TODO: check if direction is out of bounds (example: a4l invalid, cannot go left from column 'a'
	seq $t0 $s2 0 #if dir==up and row==1, then invalid
	seq $t1 $s1 1
	add $t0 $t0 $t1
	beq $t0 2 Invalid
	
	seq $t0 $s2 1 #if dir==right and column==8, then invalid
	seq $t1 $s0 8
	add $t0 $t0 $t1
	beq $t0 2 Invalid
	
	seq $t0 $s2 2 #if dir==down and row==6, then invalid
	seq $t1 $s1 6
	add $t0 $t0 $t1
	beq $t0 2 Invalid
	
	seq $t0 $s2 3 #if dir==left and column==1, then invalid
	seq $t1 $s0 1
	add $t0 $t0 $t1
	beq $t0 2 Invalid
	
	
Valid:
	li $v0 1
	jr $ra
	
Invalid:
	li $v0 0
	jr $ra


valid_loc: # location is not already filled
