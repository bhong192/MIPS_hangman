# Author: Bryant Hong, Luis Aldeco, Tommy Phong, Ben Aldrich, Emily Perez
# Date: 5/2/2021
# Description: Hangman Game 

.data

welcome: .asciiz "\nWelcome to Hangman! Guess one letter at a time to uncover the word before the person gets hung. \n"
welcome1: .asciiz "\nPlease select a random number from 1-5"

prompt: .asciiz "\nPlease enter an input: "
lostPrompt: .asciiz "\n You have killed the man :("
topBeam: .asciiz "\n	+---+\n"
secondRow: .asciiz "	|   |\n"
thirdRow: .asciiz "	    |\n"
fourthRow: .asciiz "	    |\n"
fifthRow: .asciiz "	    |\n"
sixthRow: .asciiz "	    |\n"
bottomBeam: .asciiz "	========="
correctPrompt: .asciiz "\nCorrect!"

headRow: .asciiz "        0   |\n"
bodyRow: .asciiz "	l   |\n"
onearmRow: .asciiz "       /l   |\n"
twoarmRow: .asciiz "       /l\\  |\n"
onelegRow: .asciiz "       /    |\n"
twolegRow: .asciiz "       / \\  |\n"
wordOne: .asciiz "Senpai"
wordTwo: .asciiz "Benabc"
wordThree: .asciiz "Bryant"
wordFour: .asciiz "Itzyxo"
wordFive: .asciiz "Luisxo"

.text

main:
	# print welcome prompt
	li $v0, 4
	la $a0, welcome
	syscall
	
	# draw empty Gallow 
	jal initGallow
	
	# word to be randomly chosen
	li $v0, 4
	la $a0, welcome1
	syscall 
	
	li $v0, 5
	syscall
	move $t2, $v0
	
	# inst word chosen
	beq $t2, 1, word1
	beq $t2, 2, word2
	beq $t2, 3, word3
	beq $t2, 4, word4
	beq $t2, 5, word5

gameLogic:
	li $v0, 4
	la $a0, prompt
	syscall 
	
	li $v0, 12
	syscall
	move $t1, $v0
	
	# inst $t3 as flag as false 
	li $t3, 0
	la $s0, wordOne
	lb $s1, ($s0)
	
checking:
	# out of bound exception
	beq $s1, 0, wrongGuess
	# set falg to true if found
	seq $t3, $s1, $t1
	# revealWord if flag is true and exit loop
	bgt $t3, 0, revealWord
	# increment to the nxt char to check 
	addi $s0, $s0, 1
	lb $s1, ($s0)
	j checking
	
revealWord:
	la $a0, correctPrompt
	li $v0, 4
	syscall 
	jal initGallow 
	j gameLogic 
wrongGuess:
	addi $t0, $t0, 1
	jal initGallow
	j gameLogic
	
word1:
	# setting pointer to word
	la $s0, wordOne
	lb $s1, ($s0)
	j gameLogic
	
word2:
	la $s0, wordTwo
	lb $s1, ($s0)
	j gameLogic
	
word3:
	la $s0, wordThree
lb $s1, ($s0)
	j gameLogic
	
word4:
	la $s0, wordFour
	lb $s1, ($s0)
	j gameLogic	
	
word5:
	la $s0, wordFive
	lb $s1, ($s0)
	j gameLogic
	
initGallow: 
	
	li $v0, 4
	la $a0, topBeam
	syscall
	
	li $v0, 4
	la $a0, secondRow
	syscall
	
	# head
	beq $t0, 0, noHead
	beq $t0, 1, drawHead
	beq $t0, 2, drawBody
	beq $t0, 3, drawLArm
	beq $t0, 4, drawRArm
	beq $t0, 5, drawLLeg
	beq $t0, 6, drawRLeg

	beam:
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
		j beam 

	noHead: 
		li $v0, 4
		la $a0, thirdRow
		syscall
		j beam
	
	drawBody:
		li $v0, 4
		la $a0, headRow
		syscall 
	
		li $v0, 4
		la $a0, bodyRow
		syscall 
		j beam 

	drawLArm:
		li $v0, 4
		la $a0, headRow
		syscall 
		
		li $v0, 4
		la $a0, onearmRow
		syscall
		j beam 
		
	drawRArm:
		li $v0, 4
		la $a0, headRow
		syscall 
	
		li $v0, 4
		la $a0, twoarmRow
		syscall
		j beam 
		
	drawLLeg:
		li $v0, 4
		la $a0, headRow
		syscall 
		
		li $v0, 4
		la $a0, twoarmRow
		syscall
	
		li $v0, 4
		la $a0, onelegRow
		syscall
		j beam 
		
	drawRLeg:
		li $v0, 4
		la $a0, headRow
		syscall 
	
		li $v0, 4
		la $a0, twoarmRow
		syscall
	
		li $v0, 4
		la $a0, twolegRow
		syscall
		j exit
	
exit:
	la $a0, lostPrompt
	li $v0, 4
	syscall
	
	li $v0, 10
	syscall 
