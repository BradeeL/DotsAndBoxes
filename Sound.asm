#Contributors: Mohammad Rahman, Brady Lewis, Carlos Ortiz III, Mir Patel       //ADD NAMES
#NETIDS: mzr210000, bal210004, cxo210012, mdp210002			//ADD NETIDS

#--DESCRIPTION--
#
# This file contains various subroutines to play sounds when certain events happen during the game

.globl bad_sound good_sound exit_sound

.text
bad_sound:
	move $s0 $a0 #preserve previous values from the registers
	move $s1 $a1
	move $s2 $a2
	move $s3 $a3
	move $t8 $v0
	
	li $a0 64
	li $a1 500
	li $a2 85
	li $a3 127
	li $v0 31
	syscall
	li $a0 65
	li $v0 33
	syscall
	
	li $a0 64
	li $v0 31
	syscall
	li $a0 65
	li $v0 31
	syscall
	move $a0 $s0 #restore previous values from the registers
	move $a1 $s1
	move $a2 $s2
	move $a3 $s3
	move $v0 $t8
	jr $ra
	
good_sound:
	move $s0 $a0 #preserve previous values from the registers
	move $s1 $a1
	move $s2 $a2
	move $s3 $a3
	move $t8 $v0
	li $a0 70
	li $a1 500
	li $a2 85
	li $a3 127
	li $v0 31
	syscall
	move $a0 $s0 #restore previous values from the registers
	move $a1 $s1
	move $a2 $s2
	move $a3 $s3
	move $v0 $t8
	jr $ra
	
exit_sound:
	move $s0 $a0 #preserve previous values from the registers
	move $s1 $a1
	move $s2 $a2
	move $s3 $a3
	move $t8 $v0
	li $a0 64
	li $a1 300
	li $a2 85
	li $a3 127
	li $v0 33
	syscall
	
	li $a0 60
	syscall
	
	li $a0 52
	syscall
	move $a0 $s0 #restore previous values from the registers
	move $a1 $s1
	move $a2 $s2
	move $a3 $s3
	move $v0 $t8
	
	
	jr $ra
