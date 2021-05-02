# Author: Bryant Hong, Luis Aldeco, Tommy Phong, Ben Aldrich, Emily Perez
# Date: 5/2/2021
# Description: Hangman Game 

.data

welcome: .asciiz "Welcome to Hangman! Guess one letter at a time to uncover the word before the person gets hung. \n"
topBeam: .asciiz "	+---+\n"
secondRow: .asciiz "	|   |\n"
thirdRow: .asciiz "	    |\n"
fourthRow: .asciiz "	    |\n"
fifthRow: .asciiz "	    |\n"
sixthRow: .asciiz "	    |\n"
bottomBeam: .asciiz "	========="

headRow: .asciiz "        0   |\n"
bodyRow: .asciiz "	l   |\n"
onearmRow: .asciiz "       /l   |\n"
twoarmRow: .asciiz "       /l\\  |\n"
onelegRow: .asciiz "       /    |\n"
twolegRow: .asciiz "       / \\  |\n"

guesses: .word 0

.text

main:
	# print welcome prompt
	li $v0, 4
	la $a0, welcome
	syscall
		
	
	# draw empty Gallow 
	jal initGallow
	
	
	
	
	# exit code
	li $v0, 10 
	syscall


initGallow: 
	
	la $t0, guesses
	
	li $v0, 4
	la $a0, topBeam
	syscall
	
	li $v0, 4
	la $a0, secondRow
	syscall
	
	# head
	beq $t0, 0, noHead
	bgt $t0, 1, drawHead

	
	#body and arms
	li $v0, 4
	la $a0, fourthRow
	syscall
	
	# legs
	li $v0, 4
	la $a0, fifthRow
	syscall
	
	li $v0, 4
	la $a0, sixthRow
	syscall
	
	li $v0, 4
	la $a0, bottomBeam
	syscall
	
	jr $ra

drawHead: 
	li $v0, 4
	la $a0, headRow
	syscall 
		

noHead: 
	li $v0, 4
	la $a0, thirdRow
	syscall
	jr $ra
