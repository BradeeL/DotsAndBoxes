#Contributors: Mohammad Rahman,	#//LOG: put in names and netids 
#NETID: mzr210000,   

#--DESCRIPTON--
#
# In this section of the project, the actual rules and logic of the game are 
# handled, along with requesting subroutines form other files. The Input, Update,
# Render model bein called in main will be implementing in this file as well.  #//LOG: make the descripton better

 
.data

#SETTING GLOABALS
.globl Update Render		#Setting global access for game funcitons

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

.text


#Takes in three arguments (mem_displacement, direction, turn) and edits the board stored in memory
#accordinngly and updates other game variables 	
Update:
	
#STORING USER VALUE RETURNED FROM REQUEST
	
		move $t7, $a0				#Storing arguments passed into Update call
		move $t6, $a1
	
#SWITCHING LOGIC BASED ON USER DIRECTIONAL INPUT
	
		addi $t0, $zero, 87			#is returned dir = W
		beq $t0, $t6, W
	
		addi $t0, $zero, 65			#is returned dir = A
		beq $t0, $t6, A
	
		addi $t0, $zero, 83			#is returned dir = S
		beq $t0, $t6, S
	
		addi $t0, $zero, 68			#is returned dir = D
		beq $t0, $t6, D
	
W:		addi $t7, $t7, -16			#Displace memory 
		addi $t0, $zero, 1			#Store directional flag (Vertical : 1, Horizontal : 0)
		j Exit_rSWTCH

A:		addi $t7, $t7, -1			#Displace memory
		addi $t0, $zero, 0			#Store directional flag (Vertical : 1, Horizontal : 0)
		j Exit_rSWTCH
	
S:		addi $t7, $t7, 16			#Displace memory
		addi $t0, $zero, 1			#Store directional flag (Vertical : 1, Horizontal : 0)
		j Exit_rSWTCH

D:		addi $t7, $t7, 1			#Displace memory
		addi $t0, $zero, 0			#Store directional flag (Vertical : 1, Horizontal : 0)
		j Exit_rSWTCH

Exit_rSWTCH:	move $t1, $zero				#Setting point tracker [$t1]
		addi $t2, $zero, 80			#Setting point char as P
		bne $a2, $zero, dir_branch		#Change point char setting if AI_Turn

		addi $t2, $t2, 65			#Setting point char to A
		
dir_branch:	beq $t0, $zero, Horizontal		#If (A || D --> Horizontal) else if(W || S --> Vertical)


#CHARACTER PLACEMENT AND POINT HANDLING
Vertical:	addi $t0, $zero, 124			#Store '|' into calculated memory location, $t0 holds ASCII value
		sb $t0, board($t7)
		
v_checkR:	lb $t0, -17($t7)			#Check right box lines
		beq $t0, 32, v_checkL			#If == ' ' --> break to left check (no Point)
		
		lb $t0, -2($t7)				#Check right box lines
		beq $t0, 32, v_checkL			#If == ' ' --> break to left check  (no Point)
		
		lb $t0, 15($t7)				#Check right box lines
		beq $t0, 32, v_checkL			#If == ' ' --> break to left check  (no Point)
		
		addi $t1, $t1, 1			#Award a point
		sb $t2, 1($t7)				#Storing graphical representation


v_checkL:	lb $t0, -15($t7)			#Check left box lines	
		beq $t0, 32, Exit_dirIF		#If == ' ' --> break (no Point)
		
		lb $t0, 2($t7)				#Check left box lines	
		beq $t0, 32, Exit_dirIF		#If == ' ' --> break (no Point)
		
		lb $t0, 17($t7)				#Check left box lines	
		beq $t0, 32, Exit_dirIF		#If == ' ' --> break (no Point)
		
		addi $t1, $t1, 1			#Award a point
		sb $t2, -1($t7)				#Storing graphical representation
		
		j Exit_dirIF





Horizontal:	addi $t0, $zero, 45			#Store '-' into calculated memory location, $t0 holds ASCII value
		sb $t0, board($t7)
		
h_checkU:	lb $t0, -15($t7)			#Check right box lines
		beq $t0, 32, h_checkD			#If == ' ' --> break to left check (no Point)
		
		lb $t0, -17($t7)				#Check right box lines
		beq $t0, 32, h_checkD			#If == ' ' --> break to left check  (no Point)
		
		lb $t0, -32($t7)				#Check right box lines
		beq $t0, 32, h_checkD			#If == ' ' --> break to left check  (no Point)
		
		addi $t1, $t1, 1			#Award a point
		sb $t2, -16($t7)			#Storing graphical representation


h_checkD:	lb $t0, 15($t7)				#Check left box lines	
		beq $t0, 32, Exit_dirIF		#If == ' ' --> break (no Point)
		
		lb $t0, 17($t7)				#Check left box lines	
		beq $t0, 32, Exit_dirIF		#If == ' ' --> break (no Point)
		
		lb $t0, 32($t7)				#Check left box lines	
		beq $t0, 32, Exit_dirIF		#If == ' ' --> break (no Point)
		
		addi $t1, $t1, 1			#Award a point
		sb $t2, 16($t7)				#Storing graphical representation
		
		j Exit_dirIF
		
Exit_dirIF:	beq $t1, $zero, Exit_Update		#If no points scored exit update
		
		beq $a2, $zero, AI_Turn		#Branch to appropriate turn
		
Player_Turn:	add $s6, $s6, $t1			#Adding points
		
		j Exit_Update				

AI_Turn:	add $s7, $s7, $t1			#Adding points

		j Exit_Update	
		
		
Exit_Update:	#Set game Over
		jr $ra					#return








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

exit_p:		jr $ra			#return 
