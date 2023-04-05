#Contributors: Mohammad Rahman,	#//LOG: put in names and netids 
#NETID: mzr210000,   

#--DESCRIPTON--
#
# In this section of the project, the actual rules and logic of the game are 
# handled, along with requesting subroutines form other files. The Input, Update,
# Render model bein called in main will be implementing in this file as well.  #//LOG: make the descripton better

 
.data

#SETTING GLOABALS
.globl InputRound Update Render


board: .asciiz "" 		#//LOG: Initialize ascii view of array 
p_points: 			#Current points of the player
c_points:			#Current points of the AI
max_points:			#gameOver = (p_points + c_points >= max_points) ? 1 : 0

.text
 
InputRound:	#//LOG: link to IOHandler

#RETURN TO PREVIOUS SP
jr $ra

Update:		#Views changes in memeory and updates game variables accordingly

#CALCUALATE ROUND CHANGES

#UPDATE GAME VARIABLES

#UPDATE BOARD ASCII ENCODING

#CHECK IF GAME IS OVER

#RETURN TO PREVIOUS SP
jr $ra

Render:		#Prints the current round to the console for IO with the user

#PRINT BOARD

#RETURN TO PREVIOUS SP
jr $ra

CheckPoint:  	#Checks to see if player of AI scored a point based on previous location returned by IOHandler

#ALGORITHM TO CHECK FOR A COMPLETE SQUARE

#RETURN VALUE 1 OR 0
jr $ra