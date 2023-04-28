#Contributors: Mohammad Rahman, Carlos Ortiz III, Brady Lewis	#//LOG: put in names and netids 
#NETID: mzr210000, cxo210012, bal210004

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
#		~ valic_loc call unknown (how do I pass in a coord & dir?) ~
#		~ ditto for update ~
#		~ depending on above, may have to shift 0-5 -> 1-6 or change how "D/R" are passed in ~
#
# for(int i=1; i<=SZ_X; i++)
#	for(char j='A'; j<=SZ_Y; j++)
#	{
#		Decode(i,j,'D')
#		if(CheckDirOut(disp, dir))
#		{
#			Decode(i,j,'D')
#			update(i,j,'D');
#			if(update(...))
#				i=1; j='A';
#			return;
#		}
#		Decode(i,j,'R')
#		if(CheckDirOut(disp, dir))
#		{
#			Decode(i,j,'D')
#			update(i,j,'R');
#			if(update(...))
#				i=1; j='A';
#			return;
#		}
#	}
# return;

#AIExec: does a couple whiles and sees if it can place a line onto (x,y) facing D/R for each peg on the grid
.globl AIExec
AIExec:

# Let t0 = i, t1 = j, t2 = SZ_X, t3 = SZ_Y
addi $t0, $zero, 0
addi $t1, $zero, 0
addi $t2, $zero, 6
addi $t3, $zero, 8

ai_forx:		#while(
bge $t0, $t2, ai_endx	# t0 != SZ_X )

#since it's a while loop, you gotta restart y each time you run x
addi $t1, $zero, 0

ai_fory:		#while(
bge $t1, $t3, ai_endy	# t1 != SZ_Y )

#### Right neighbor check

#assume CheckDirOut also handles oob scenarios
			#if(CheckDirOut(i,j,'R'))
#move $a0, $t0
#move $a1, $t1
#it's (c,r,D) not (r,c,D)
move $a0, $t1
move $a1, $t0
addi $a2, $zero, 1

#if(y=7) v0=0
sne $v0, $t1, 7

#if CheckDirOut is true,
beqz $v0, ai_rupdend

# check if I can actually place (disp,dir)
# pseduo: if (board(disp,dir)!=' ') $v0=0

move $a0, $t1
move $a1, $t0
addi $a2, $zero, 1

# store current (i,j) and (imax,jmax) [sorry it looks repetitive but it's the best I got outside of making like 20 functions]
#(i,j,'R') -> (disp, dir)
addi $sp, $sp, -20
sw $t0, 16($sp)
sw $t1, 12($sp)
sw $t2, 8($sp)
sw $t3, 4($sp)
sw $ra, 0($sp)

jal Decode

lw $ra, 0($sp)
lw $t3, 4($sp)
lw $t2, 8($sp)
lw $t1, 12($sp)
lw $t0, 16($sp)
addi $sp, $sp, 20

addi $v0, $v0, 1
lb $t4, board($v0)
seq $v0, $t4, 32

# end check

#if the spot on the board is taken, move on to the next check
beqz $v0, ai_rupdend

#update(i,j,'R')
#move $a0, $t0
#move $a1, $t1
#it's (c,r,D) not (r,c,D)
move $a0, $t1
move $a1, $t0
addi $a2, $zero, 1

#(i,j,'R') -> (disp, dir)
addi $sp, $sp, -20
sw $t0, 16($sp)
sw $t1, 12($sp)
sw $t2, 8($sp)
sw $t3, 4($sp)
sw $ra, 0($sp)

jal Decode

lw $ra, 0($sp)
lw $t3, 4($sp)
lw $t2, 8($sp)
lw $t1, 12($sp)
lw $t0, 16($sp)
addi $sp, $sp, 20

move $a0, $v0
move $a1, $v1
addi $a2, $zero, 0	#update has to know if it's an AI

# (disp, dir) -> update(disp, dir)

addi $sp, $sp, -20
sw $t0, 16($sp)
sw $t1, 12($sp)
sw $t2, 8($sp)
sw $t3, 4($sp)
sw $ra, 0($sp)

jal Update

lw $ra, 0($sp)
lw $t3, 4($sp)
lw $t2, 8($sp)
lw $t1, 12($sp)
lw $t0, 16($sp)
addi $sp, $sp, 20

# update returns 0/1 depending on if it scored

j ai_endx #end subrt

#otherwise, move on
ai_rupdend:

#### Down neighbor check

#move $a0, $t0
#move $a1, $t1
#it's (c,r,D) not (r,c,D)
move $a0, $t1
move $a1, $t0
addi $a2, $zero, 2	#if(CheckDirOut(i,j,'D')) ; (i,j) should not change since last call but just in case

#if(x=5) v0=0
sne $v0, $t0, 5

#if CheckDirOut does not allow us to go, branch
beqz $v0, ai_dupdend

# check if I can actually place (disp,dir)
# pseduo: if (board(disp,dir)!=' ') $v0=0
move $a0, $t1
move $a1, $t0
addi $a2, $zero, 2

#(i,j,'R') -> (disp, dir)
addi $sp, $sp, -20
sw $t0, 16($sp)
sw $t1, 12($sp)
sw $t2, 8($sp)
sw $t3, 4($sp)
sw $ra, 0($sp)

jal Decode

lw $ra, 0($sp)
lw $t3, 4($sp)
lw $t2, 8($sp)
lw $t1, 12($sp)
lw $t0, 16($sp)
addi $sp, $sp, 20

addi $v0, $v0, 16
lb $t4, board($v0)
seq $v0, $t4, 32

#if the spot on the board is taken, move on to the next check
beqz $v0, ai_dupdend

#update(i,j,'D')
#move $a0, $t0
#move $a1, $t1
#it's (c,r,D) not (r,c,D)
move $a0, $t1
move $a1, $t0
addi $a2, $zero, 2

#(i,j,'R') -> (disp, dir)
addi $sp, $sp, -20
sw $t0, 16($sp)
sw $t1, 12($sp)
sw $t2, 8($sp)
sw $t3, 4($sp)
sw $ra, 0($sp)

jal Decode

lw $ra, 0($sp)
lw $t3, 4($sp)
lw $t2, 8($sp)
lw $t1, 12($sp)
lw $t0, 16($sp)
addi $sp, $sp, 20

move $a0, $v0
move $a1, $v1
addi $a2, $zero, 0	#update has to know if it's an AI

# (disp, dir) -> update(disp, dir)

addi $sp, $sp, -20
sw $t0, 16($sp)
sw $t1, 12($sp)
sw $t2, 8($sp)
sw $t3, 4($sp)
sw $ra, 0($sp)

jal Update

lw $ra, 0($sp)
lw $t3, 4($sp)
lw $t2, 8($sp)
lw $t1, 12($sp)
lw $t0, 16($sp)
addi $sp, $sp, 20

# update returns 0/1 depending on if it scored

#jal Update #update grid
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

#if you get here w/o modifying board, board is full.

jr $ra
