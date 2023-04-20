#Contributors: Mohammad Rahman,        //ADD NAMES
#NETIDS: mzr210000, 			//ADD NETIDS

#--DESCRIPTION--
#
# In this file, the game values are stored in memory (initialized) and put into a 
# loop which runs the game in 3 stages: Input, Update, Render. These subroutines are
# defined in other files, but are put together in main.

#PRE-DEFINED CONSTANTS
# define PLAYER_TURN 1
# define AI_TURN 0

#PRE-DEFINED REGISTERS
# define $s7 : player points
# define $s6 : AI points
# define $s5 : max points
# define $s4 : game over flag

.data

.globl main

.text

#Runs main loop of the program 
main:		
		
		

main_Loop:	jal Render			#Print board to console
		
		jal Request			#Request user input with validity handling
		
		move $a0, $v0			#Passes return values of Request(mem_displacement, direction, turn)
		move $a1, $v1			#to arguments for Update.
		addi $a2, $zero, 1		#Turn = 1 = player
		
		jal Update			#Function call update
		
		jal Render			#Render User move
		jal AIExec			#AI Turn
	
		#LOOPING
		bne $zero, $s4, exit_game	#If game is not over(0) --> loop
	
		j main_Loop			#Loop back to Render function call
	
		#GAME FINISHED
exit_game:	li $v0 10 			#exit program
		syscall
