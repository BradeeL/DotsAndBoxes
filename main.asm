#Contributors: Mohammad Rahman, Brady Lewis, Carlos Ortiz III, Mir Patel       //ADD NAMES
#NETIDS: mzr210000, bal210004, cxo210012, mdp210002			//ADD NETIDS

#--DESCRIPTION--
#
# In this file, the game values are stored in memory (initialized) and put into a 
# loop which runs the game in 4 steps: Render, Request, Update. and AIExec These subroutines are
# defined in other files, but are put together in main.

#PRE-DEFINED CONSTANTS
# define PLAYER_TURN 1
# define AI_TURN 0
# define (return from Update) SCORED_POINT 1
# define (return from Update) !SCORED_POINT 0
#define GAMEOVER 1
#define !GAMEOVER 0

#PRE-DEFINED REGISTERS
# define $s7 : AI points
# define $s6 : Player points
# define $s5 : max points
# define $s4 : game over flag

.data

.globl main exit_game

#PROMPTS
p_winner: .asciiz "Congratulations, You won!"
a_winner: .asciiz "HAHAHAHAHHAH, you lost I won"


.text

#Runs main loop of the program 
main:		addi $s4, $zero, 0		#Initializing pre-defined registers (gameover flag, maxpoints)
		addi $s5, $zero, 35




main_Loop:	jal Render			#Print board to console
		
		jal Request			#Request user input with validity handling returns (memory deplacement and dir of coordinate)
		
		jal good_sound
		
		move $a0, $v0			#Passes return values of Request(mem_displacement, direction, turn)
		move $a1, $v1			#to arguments for Update.
		addi $a2, $zero, 1		#Turn = 1 = player
		
		jal Update			#Function call update
		
#TURN HANDLING
		bne $zero, $s4, exit_game	#If game is not over(0) --> loop
		bne $v0, $zero, main_Loop	#Loop back if player scored points




AI_Loop:	jal AIExec			#AI Turn

#TURN HANDLING
		bne $zero, $s4, exit_game	#If game is not over(0) --> loop
		bne $v0, $zero, AI_Loop	#Loop back if AI scored points
	
	
#LOOPING
		j main_Loop			#Loop back to Render function call
		

	
#GAME FINISHED
exit_game:	
		jal exit_sound
		
		li $v0 4			#Set syscall code to print string
		
		slt $t0, $s7, $s6		#Store if user scored more point ? 1 : 0
		
		la $a0, p_winner		#Predict Player win and set Player win prompt
		
		bne $t0, $zero, PlayerW	#If player points < AI points --> print and end game
				
		la $a0, a_winner		#Set AI win prompt


PlayerW:	syscall				#Print winner prompt
		
		li $v0 10 			#exit program
		syscall
