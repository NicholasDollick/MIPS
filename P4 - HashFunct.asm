#Name: Nicholas Dollick        

.data

inputStr: 	.asciiz "I can't wait for the dr. who xmas special!" 
#Angie and I went walking
#this is not life
#programmers are so..., -how do you say...
#I can't wait for the dr. who xmas special!
x: 		.word 31 #the base (radix)
out1:		.asciiz "The hashed value of "
out2:		.asciiz " is: "



#str2: .asciiz "Frankenstein"

eos: .byte '\0'

.text 
.main

	addi $t6, $zero, 104729
	addi $t1, $zero, 0 # h = 0
	la $a0, inputStr 
	li $a1, 3 #the length of the string 
	li $t0, 0
	jal hash 
	move $v0, $t1
	
	#the answer should now be in $v0,so save it in $s0
	move $s0, $v0 
	
	#print first part of output
	li $v0, 4 
	la $a0, out1
	syscall
	
	#print string being hashed
	li $v0, 4
	la $a0, inputStr
	syscall
	
	#print back end of output 
	li $v0, 4
	la $a0, out2
	syscall
	
	#print hashed value
	li $v0, 1
	add $a0, $zero, $s0
	syscall
	
	#exit 
	li $v0, 10 
	syscall 
	
	#begin int hash(char* v, int M) 
	hash:
		add $s1, $a0, $t0 # initialize bit pointer position
		lb $s2, 0($s1) # load one bit into register
		beq $s2, $zero, bounce # if character is \0, exit method
		
		
		mul  $t1, $t1, 31 # h = h * 31
		mflo $t3 #store result
		add $t1, $t3, $s2 # h = h + *v
		div $t1, $t6 # h % M
		mfhi $t1 #h = h % M
		addi $t0, $t0, 1 # v++
		j hash
	
	#end hash()
	bounce:
		jr $ra