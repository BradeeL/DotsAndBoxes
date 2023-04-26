.globl bad_sound good_sound

.text
j good_sound
bad_sound:
	li $a0 64
	li $a1 100
	li $a2 1
	li $a3 127
	li $v0 31
	syscall
	li $a0 65
	li $a1 100
	li $a2 1
	li $a3 127
	li $v0 33
	syscall
	
	li $a0 64
	li $a1 100
	li $a2 1
	li $a3 127
	li $v0 31
	syscall
	li $a0 65
	li $a1 100
	li $a2 1
	li $a3 127
	li $v0 33
	syscall
	jr $ra
	
good_sound:
	li $a0 70
	li $a1 100
	li $a2 16
	li $a3 127
	li $v0 31
	syscall