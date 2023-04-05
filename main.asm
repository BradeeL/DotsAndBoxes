#Contributors: Mohammad Rahman,        //ADD NAMES
#NETIDS: mzr210000, 			//ADD NETIDS

#--DESCRIPTION--
#
# In this file, the game values are stored in memory (initialized) and put into a 
# loop which runs the game in 3 stages: Input, Update, Render. These subroutines are
# defined in other files, but are put together in main.

#//LOG!!!!!!: Make proper stack pointer conventions for project

.data

.globl main
.globl gameOver

gameOver: .byte 0

.text

 
main:

		jal InputRound  #//LOG: labels do not exist yet, put in for temorary structure
		jal Update
		jal Render
	
	
		#LOOPING
		lw $t7, gameOver		#Transer global game tracker
		bne $zero, $t7, exit_game	#If game is not over(0) --> loop
	
		j main
	
		#GAME FINISHED
exit_game:	li $v0 10 			#exit program
		syscall