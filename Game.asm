#Contributors: Mohammad Rahman,	#//LOG: put in names and netids 
#NETID: mzr210000,   

#--DESCRIPTON--
#
# In this section of the project, the actual rules and logic of the game are 
# handled, along with requesting subroutines form other files. The Input, Update,
# Render model bein called in main will be implementing in this file as well.  #//LOG: make the descripton better

 
.data

#SETTING GLOABALS
.globl Update Render 		#Setting global access for game funcitons

.globl board			#Setting gloabal access for game board

 
#Initialize ASCII array
board: 
		#A B C D E F G H	#Null character not show! take into caluclation 11x16 2D-arr.
	.asciiz ". . . . . . . ."	# 1
	.asciiz "               "
	.asciiz ". . . . . . . ."	# 2
	.asciiz "               "
	.asciiz ". . . . . . . ."	# 3
	.asciiz "               "
	.asciiz ". . . . . . . ."	# 4
	.asciiz "               "
	.asciiz ". . . . . . . ."	# 5
	.asciiz "               "
	.asciiz ". . . . . . . ."	# 6
	
boardHLabel: .asciiz "A B C D E F G H\n" 
playerPoints: .asciiz "\nPlayer Points: "
AIPoints: .asciiz "\nAI Points: "

.text


#Takes in three arguments (mem_displacement, direction, turn) and edits the board stored in memory
#accordinngly and updates other game variables 	
Update:
	
#STORING USER VALUE RETURNED FROM REQUEST
	
		move $t7, $a0				#Storing arguments passed into Update call
		move $t6, $a1
	
#SWITCHING LOGIC BASED ON USER DIRECTIONAL INPUT

		addi $t0, $zero, 0			#is returned dir = U
		beq $t0, $t6, U

		addi $t0, $zero, 1			#is returned dir = R
		beq $t0, $t6, R

		addi $t0, $zero, 2			#is returned dir = D
		beq $t0, $t6, D
		
		addi $t0, $zero, 3			#is returned dir = L
		beq $t0, $t6, L

	
U:		addi $t7, $t7, -16			#Displace memory 
		addi $t0, $zero, 1			#Store directional flag (Vertical : 1, Horizontal : 0)
		j Exit_rSWTCH

L:		addi $t7, $t7, -1			#Displace memory
		addi $t0, $zero, 0			#Store directional flag (Vertical : 1, Horizontal : 0)
		j Exit_rSWTCH
	
D:		addi $t7, $t7, 16			#Displace memory
		addi $t0, $zero, 1			#Store directional flag (Vertical : 1, Horizontal : 0)
		j Exit_rSWTCH

R:		addi $t7, $t7, 1			#Displace memory
		addi $t0, $zero, 0			#Store directional flag (Vertical : 1, Horizontal : 0)
		j Exit_rSWTCH

Exit_rSWTCH:	move $t1, $zero				#Setting point tracker [$t1]
		addi $t2, $zero, 80			#Setting point char as P
		bne $a2, $zero, dir_branch		#Change point char setting if AI_Turn

		addi $t2, $zero, 65			#Setting point char to A
		
dir_branch:	move $v0, $zero
		beq $t0, $zero, Horizontal		#If (A || D --> Horizontal) else if(W || S --> Vertical)


#CHARACTER PLACEMENT AND POINT HANDLING

Vertical:	addi $t0, $zero, 124			#Store '|' into calculated memory location, $t0 holds ASCII value
		sb $t0, board($t7)
		move $t4, $t7
		la $t3, board
		add $t7, $t7, $t3
		addi $t3, $zero, 16
		
v_checkR:	addi $t4, $t4, 2
		div $t4, $t3
		mfhi $t3
		addi $t4, $t4, -2
		beq $t3, $zero, v_checkL

		lb $t0, 17($t7)			#Check right box lines
		beq $t0, 32, v_checkL			#If == ' ' --> break to left check (no Point)
		
		lb $t0, 2($t7)				#Check right box lines
		beq $t0, 32, v_checkL			#If == ' ' --> break to left check  (no Point)
		
		lb $t0, -15($t7)				#Check right box lines
		beq $t0, 32, v_checkL			#If == ' ' --> break to left check  (no Point)
		
		addi $t1, $t1, 1			#Award a point
		addi $v0, $zero, 1			#Setting return value
		sb $t2, 1($t7)				#Storing graphical representation


v_checkL:	addi $t3, $zero, 16
		div $t4, $t3				#Checking if left most column is selected
		mfhi $t3
		beq $zero, $t3, Exit_dirIF
		
		
		lb $t0, 15($t7)			#Check left box lines	
		beq $t0, 32, Exit_dirIF		#If == ' ' --> break (no Point)
		
		lb $t0, -2($t7)				#Check left box lines	
		beq $t0, 32, Exit_dirIF		#If == ' ' --> break (no Point)
		
		lb $t0, -17($t7)				#Check left box lines	
		beq $t0, 32, Exit_dirIF		#If == ' ' --> break (no Point)
		
		addi $t1, $t1, 1			#Award a point
		addi $v0, $zero, 1			#Setting return value
		sb $t2, -1($t7)				#Storing graphical representation
		
		j Exit_dirIF





Horizontal:	addi $t0, $zero, 45			#Store '-' into calculated memory location, $t0 holds ASCII value
		sb $t0, board($t7)
		move $t4, $t7
		la $t3, board
		add $t7, $t7, $t3
		
		
h_checkU:	slti $t3, $t4, 16
		bne $t3, $zero, h_checkD 
		
		lb $t0, -15($t7)			#Check right box lines
		beq $t0, 32, h_checkD			#If == ' ' --> break to left check (no Point)
		
		lb $t0, -17($t7)				#Check right box lines
		beq $t0, 32, h_checkD			#If == ' ' --> break to left check  (no Point)
		
		lb $t0, -32($t7)				#Check right box lines
		beq $t0, 32, h_checkD			#If == ' ' --> break to left check  (no Point)
		
		addi $t1, $t1, 1			#Award a point
		addi $v0, $zero, 1			#Setting return value
		sb $t2, -16($t7)			#Storing graphical representation


h_checkD:	slti $t3, $t4, 160
		beq $t3, $zero, Exit_dirIF
		
		lb $t0, 15($t7)				#Check left box lines	
		beq $t0, 32, Exit_dirIF		#If == ' ' --> break (no Point)
		
		lb $t0, 17($t7)				#Check left box lines	
		beq $t0, 32, Exit_dirIF		#If == ' ' --> break (no Point)
		
		lb $t0, 32($t7)				#Check left box lines	
		beq $t0, 32, Exit_dirIF		#If == ' ' --> break (no Point)
		
		addi $t1, $t1, 1			#Award a point
		addi $v0, $zero, 1			#Setting return value
		sb $t2, 16($t7)				#Storing graphical representation
		
		j Exit_dirIF
		
Exit_dirIF:	beq $t1, $zero, Exit_UpdateN		#If no points scored exit update
		
		beq $a2, $zero, AI_Turn		#Branch to appropriate turn
		
Player_Turn:	add $s6, $s6, $t1			#Adding points
		
		j Exit_UpdateN				

AI_Turn:	add $s7, $s7, $t1			#Adding points

		j Exit_UpdateN	

Exit_UpdateN:	add $t0, $s7, $s6			#Set game Over
		beq $t0, $s5, Exit_UpdateE 
		
		jr $ra					#return
		

Exit_UpdateE:  addi $s4, $zero, 1			#Set game over  







#Description: Prints the corresponding labels and board from memory 
Render:

#SETTING UP CONTROL FLOW VARIABLES AND MEMORY POINTER	

		move $t0, $zero		#Setting index register for memory traversal
		move $t1, $zero 	#Setting termenation register
		addi $t2, $zero, 11    #Storing termination value
		addi $t3, $zero, 2	#Storing modulo calculation constant
		
#PRINTING HEADER
		li $v0, 11		#TAB for formatting
		li $a0, 9
		syscall 		#print

		li $v0, 4		#Setting syscal code to print string
		la $a0, boardHLabel	#Loading addr of boardHLabel
		syscall			#print
				
#PRINTING BOARD

Loop_p:		beq $t1, $t2, exit_p	#if($t1 == 11) --> break loop, Main loop
	
		div $t1, $t3		#Current index % 2
		mfhi $t4		#Grab remainder
		bne $t4, $zero, Loop_b	#if remainder == 0 --> Print label; Else --> skip
		
		li $v0, 1		#Print integer row labels
		srl $a0, $t1, 1		#$a0 = $t0/2
		addi $a0, $a0, 1	#load current row + 1
		syscall			#print
		
Loop_b:		li $v0, 11		#TAB for formatting
		li $a0, 9
		syscall			#print 
		
	
		li $v0, 4		#Setting syscall code to print string
		la $a0, board($t0) 	#Loading address of row [$t0} for arg
		syscall 		#print
		
		li $v0 11		#Setting syscall to print char
		li $a0 10		#Printing newline
		syscall
		
		addi $t0, $t0, 16	#Move address to next row
		addi $t1, $t1, 1	#Increment termination counter 	

		j Loop_p		#loop functionality

exit_p:		li $v0, 4
		la $a0, playerPoints 	#Print /n
		syscall
		
		li $v0 1
		move $a0, $s6		#Print player points
		syscall
		
		li $v0, 4
		la $a0, AIPoints 	#Print \n
		syscall
		
		li $v0, 1
		move $a0, $s7		#Print player points
		syscall
		
		li $v0, 11
		li $a0, 10		#print \n
		syscall
		
		
		jr $ra			#return 
