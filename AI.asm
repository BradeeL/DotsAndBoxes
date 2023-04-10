#Contributors: Mohammad Rahman, Carlos Ortiz III	#//LOG: put in names and netids 
#NETID: mzr210000, cxo210012

#--DESCRIPTON--
#
# This file handles the AIs methods and inputs "against" the Player
#~~//LOG: plan out ..... later~~

.data

##### Debug formatting
oPn: .asciiz "at: ("
comma: .asciiz ", "
cPn: .asciiz ")\n"
#####

.text

# Simple "Winning" algorithm:
# Let SZ_X = 6, SZ_Y = 'H'
#
#	Pseudocode:
#		For every point in the matrix, check its down & right connections positions to see if it is taken;
#		if not, place it into grid and end program.
#	Obstacles:
#		- valic_loc call unknown (how do I pass in a coord & dir?)
#		- ditto for update
#		- depending on above, may have to shift 0-5 -> 1-6 or change how "D/R" are passed in
#
# for(int i=1; i<=SZ_X; i++)
#	for(char j='A'; j<=SZ_Y; j++)
#	{
#		if(valid_loc(i,j,'D'))
#		{
#			update(i,j,'D');
#			return;
#		}
#		if(valid_loc(i,j,'R'))
#		{
#			update(i,j,'R');
#			return;
#		}
#	}
# return;

#AIExec: does a couple whiles and sees if it can place a line onto (x,y) facing D/R for each peg on the grid
.globl AIExec
AIExec:

# Let t0 = i, t1 = j, t2 = SZ_X, t3 = SZ_Y
move $t0, $zero
addi $t1, $zero, 'A'
addi $t2, $zero, 6
addi $t3, $zero, 'I'
move $t4, $ra		# store $ra for later

#store a0-2 (unsure if necessary)
#move $t4, $a0
#move $t5, $a1
#move $t6, $a2

ai_forx:		#while(
beq $t0, $t2, ai_endx	# t0 != SZ_X )

#since it's a while loop, you gotta restart y each time you run x
addi $t1, $zero, 'A'

ai_fory:		#while(
beq $t1, $t3, ai_endy	# t1 != SZ_Y )

#### Right neighbor check


#FOR TESTING PURPOSES
#FOR TESTING PURPOSES
#FOR TESTING PURPOSES
#Remove if you want neater code; I left this in just to show how it traverses the board

#out: (
li $v0, 4
la $a0, oPn
syscall

#x
li $v0, 1
move $a0, $t0
syscall

#,
li $v0, 4
la $a0, comma
syscall

#x
li $v0, 1
move $a0, $t1
syscall

#)
li $v0, 4
la $a0, cPn
syscall

#END FOR TESTING PURPOSES
#END FOR TESTING PURPOSES
#END FOR TESTING PURPOSES

# Depending on how grid is traversed,
# I may need to alter how update() works
# I'll fix this fully once I/we get a solid understanding of the board going

#assume valid_loc also handles oob scenarios
			#if(valid_loc(i,j,'R'))
move $a0, $t0
move $a1, $t1
addi $a2, $zero, 'R'
jal valid_loc

#if so
bne $v0, 1, ai_rupdend

#update(i,j,'R')
move $a0, $t0
move $a1, $t1
addi $a2, $zero, 'R'
jal Update #update grid (?)
j ai_endx #end subrt

#otherwise, move on
ai_rupdend:

#### Down neighbor check

move $a0, $t0
move $a1, $t1
addi $a2, $zero, 'D'	#if(valid_loc(i,j,'D')) ; (i,j) should not change since last call but just in case
jal valid_loc

#if so
bne $v0, 1, ai_dupdend

#update(i,j,'D')
move $a0, $t0
move $a1, $t1
addi $a2, $zero, 'D'
jal Update #update grid
j ai_endx #end subrt

ai_dupdend:

addi $t1, $t1, 1
j ai_fory

#endy
ai_endy:

#endx
addi $t0, $t0, 1
j ai_forx

ai_endx:

move $ra, $t4	# restore $ra

jr $ra
