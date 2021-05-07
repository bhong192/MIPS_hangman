# Author: Bryant Hong, Luis Aldeco, Tommy Phong, Ben Aldrich, Emily Perez
# Date: 5/2/2021
# Description: Hangman Game 

.data

welcome: .asciiz "\nWelcome to Hangman! Guess one letter at a time to uncover the word before the person gets hung. \n"
welcome1: .asciiz "\nPlease select a random number from 1-5: "

prompt: .asciiz "\nPlease enter an input: "
lostPrompt: .asciiz "\n You have killed the man :("
winPrompt: .asciiz "\n You have saved the man :)"
topBeam: .asciiz "\n	+---+\n"
secondRow: .asciiz "	|   |\n"
thirdRow: .asciiz "	    |\n"
fourthRow: .asciiz "	    |\n"
fifthRow: .asciiz "	    |\n"
sixthRow: .asciiz "	    |\n"
bottomBeam: .asciiz "	========="
correctPrompt: .asciiz "\nCorrect!"
newline: .asciiz "\n"
dupPrompt: .asciiz "\nYou Entered a Duplcate input!"

headRow: .asciiz "        0   |\n"
bodyRow: .asciiz "	l   |\n"
onearmRow: .asciiz "       /l   |\n"
twoarmRow: .asciiz "       /l\\  |\n"
onelegRow: .asciiz "       /    |\n"
twolegRow: .asciiz "       / \\  |\n"
wordOne: .asciiz "Senpai"
wordTwo: .asciiz "Action"
wordThree: .asciiz "Kraken"
wordFour: .asciiz "GitHub"
wordFive: .asciiz "Quartz"
guessArray: .byte  '_',' ','_',' ','_',' ','_',' ','_',' ','_',' '
win: .word 0

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
	move $s7, $v0
	
	#allocate 50 bytes of memory for array
	li $a0, 50
	li $v0, 9
	syscall
	move $s6, $v0
	move $s5, $s6
	
	#save return address
	la  $ra, gameLogic
	
wordChoice:
	
	# inst word chosen
	beq $s7, 1, word1
	beq $s7, 2, word2
	beq $s7, 3, word3
	beq $s7, 4, word4
	beq $s7, 5, word5

gameLogic:
	#check if you won game
	lw $t6, win
	beq $t6, 6, winGame

	#ask for a letter
	li $v0, 4
	la $a0, prompt
	syscall 
	
	li $v0, 12
	syscall
	move $t1, $v0
	
	#resent index j
	move $t7, $0
	move $s4, $s5
	#check if the new input is a duplicate
	bne $s6, $s5, checkDup
	
	nodup:
	#save new letter to array
	sb $t1, ($s6)
	
	#increament pointer
	addi $s6, $s6, 1
	
	# inst $t3 as flag as false 
	li $t3, 0
	jal wordChoice
	
	#int i = 0 
	#counter used as index for pos in word
	move $s3, $0
	
checking:
	# out of bound exception
	beq $s1, 0, wrongGuess
	# set flag to true if found
	seq $t3, $s1, $t1
	# revealWord if flag is true and exit loop
	bgt $t3, 0, revealWord
	# increment to the nxt char to check 
	addi $s0, $s0, 1
	addi $s3, $s3, 1
	lb $s1, ($s0)
	j checking
	
checkDup:
	#loops through entire array to check if the new input is the same
	beq $t7, 50, nodup
	
	#load current letter in array
	lb $t8, ($s4)
	
	#check if input is the same to letter
	seq $t8, $t8, $t1
	beq $t8, 1, dup
	
	#increament pointer and index
	addi $t7, $t7, 1
	addi $s4, $s4, 1
	j checkDup
	
dup:

	# print welcome prompt
	li $v0, 4
	la $a0, dupPrompt
	syscall
	
	j gameLogic
	
revealWord:
	#keeps track of how many letters are revealed
	addi $t6, $t6, 1
	sw $t6, win

	#print correct prompt
	la $a0, correctPrompt
	li $v0, 4
	syscall 
	
	#reveal letter
	la $s2, guessArray
	#account for spaces in array
	sll $t4, $s3, 1
	#get address for corresponding pos
	add $t5,$s2,$t4
	#save new char in pos
	sb $t1, ($t5)
	
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
	jr $ra
	
word2:
	la $s0, wordTwo
	lb $s1, ($s0)
	jr $ra
	
word3:
	la $s0, wordThree
	lb $s1, ($s0)
	jr $ra
	
word4:
	la $s0, wordFour
	lb $s1, ($s0)
	jr $ra	
	
word5:
	la $s0, wordFive
	lb $s1, ($s0)
	jr $ra
	
initGallow: 

	la $a0, newline		 
	li $v0, 4
	syscall
	
	#print array
	la $a0, guessArray		 
	li $v0, 4
	syscall
	
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
		j lostGame
		
	
lostGame:
	la $a0, lostPrompt
	li $v0, 4
	syscall
	j exit	
winGame:
	la $a0, winPrompt
	li $v0, 4
	syscall
	j exit	

exit:
	li $v0, 10
	syscall 
