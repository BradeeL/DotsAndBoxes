#Contributors: Mohammad Rahman, Brady Lewis       //ADD NAMES
#NETIDS: mzr210000, bal210004			//ADD NETIDS

#--DESCRIPTION--
#
# This file contains various subroutines to play sounds when certain events happen during the game

.globl bad_sound good_sound exit_sound point_sound

.text
bad_sound:
	li $a0 64
	li $a1 500
	li $a2 16
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
	jr $ra
	
good_sound:
	li $a0 70
	li $a1 500
	li $a2 16
	li $a3 127
	li $v0 31
	syscall
	jr $ra
	
exit_sound:
	li $a0 64
	li $a1 300
	li $a2 40
	li $a3 127
	li $v0 33
	syscall
	
	li $a0 60
	syscall
	
	li $a0 52
	syscall
	jr $ra

point_sound:
	li $a0 58
	li $a1 500
	li $a2 16
	li $a3 127
	li $v0 33
	syscall
	
	li $a0 70
	syscall
	jr $ra