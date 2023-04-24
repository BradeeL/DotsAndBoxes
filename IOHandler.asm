#Contributors: Mohammad Rahman, Brady Lewis	#//LOG: put in names and netids 
#NETID: mzr210000, bal210004

#--DESCRIPTON--
#
# Handles decoding user input into array spacing on board and 
# notifying the Game.asm file how to update its values


#psuedocode:
#	get userinput, format ([column][row][u|d|l|r])
#	example: "a4d" means a4 down, connect points a4 and a5 on the board.
#	check for valid column and valid row (a-h) (1-6)
#	if not valid, loop
#	if valid, check for valid directional input
#	check for 'u' 'd' 'l' or 'r'
#	$s0 = column num (a-h -> 1-8)
#	$s1 = row num (1-6)
#	$s2 = direction (0=up, 1=right, 2=down, 3=left)
#hll code:
#	char validDirs[]={'u','r','d','l'};
#	int dir;
#	do{
#		invalidInput=false;
#		getline(&usrIn,&len,stdin);
#		if(usrIn[0]==NULL||usrIn[1]==NULL||usrIn[2]==NULL){invalidInput=true;}
#		else{
#			usrIn[0].toUpperCase();//andi $t0 $t0 95 (sets 5th bit to 0)
#			if(usrIn[0]<65||usrIn[0]>72)
#				invalidInput=true;
#			else if(usrIn[1]<1||usrIn[1]>6)
#				invalidInput=true;
#			else{
#				for(int i=0;i<4;i++){
#					if(usrIn==validDirs[i]){
#						dir=i;
#						if((dir==0&&usrIn[1]==1)||(dir==1&&usrIn[0]==72)||(dir==2&&usrIn[1]==6)||(dir==3&&usrIn[0]==65))
#							invalidInput=true;
#						else
#							invalidInput=false;
#						break;
#					}
#					invalidInput=true;
#				}
#				
#			}
#		}while(invalidInput);

.data

.globl Request Decode

validDirs: .asciiz "URDL"
inPrompt: .asciiz "\nPlease enter a move ([column][row][ u | d | l | r ]: "
input: .space 4
invalidPrompt: .asciiz "\nThat move is invalid. Consult manual for correct format.\n"
.text

Request: 
	addi $sp $sp -4#store return address for main
	sw $ra 4($sp)
	
	
	#Request string from user input
	la $a0 inPrompt
	li $v0 4
	syscall
	
	la $a0 input
	la $a1 4
	li $v0 8
	syscall
	
	jal input_check
	
	beq $v0 0 InvalidLoop
	
	move $a0 $s1
	move $a1 $s0
	move $a2 $s2
	
	jal Decode
	
	addi $sp $sp 4
	lw $ra ($sp)
	jr $ra
	
InvalidLoop:
	la $a0 invalidPrompt
	li $v0 4
	syscall
	j Request
	

#Description: Takes in arguments: Row [$a0], Colomn [$a1], Direction [$a2]
#and returns the corrisponding memory_displacement [$v0] and direction [$v1]
Decode:
	
			addi $t0, $zero, 32	#r*2*16 --> r*32
			mult $a1, $t0
			mflo $a1
			
			addi $t0, $zero, 2	#c*2
			mult $a0, $t0
			mflo $a0
	
			add $v0, $a1, $a0	#(r*2)*16 + (c*2)
			move $v1, $a2		#direction [WASD]
	
			jr $ra			#return
	
