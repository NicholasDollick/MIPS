#######################
# Nicholas Dollick    #
# Math 230            #
# Project 3           #
#######################
.data
#pre-made promp messages
Prompt_encDec:           .asciiz "Type 'e' to encrypt or 'd' to decrypt: "
Prompt_AddKey:           .asciiz "Choose an addition key: "
Prompt_ChooseBitToggle:  .asciiz "Enter bit toggle key: "
Prompt_AskForText:       .asciiz "Enter text to encrypt: "
encryptOutput:           .asciiz "Encrypted text: "
decryptOutput:           .asciiz "Decrypted text: "
input:                   .space 255    


#inputs
INBUFFER:    .byte 0xff:100 #filling memory with this to make it easy to see

#outputs 
OUTBUFFER:   .byte 0xee:100 #filling memory with this to make it easy to see

.text

    # prompt user to input 'e' or 'd'
    li $v0, 4
    la $a0, Prompt_encDec
    syscall

    # read encrypt or decrypt choice
    li $v0, 12    	# set syscall to read char
    syscall
    add $t0, $v0, $0	# store returned value
    li $v0, 11
    li $a0, 10    
    syscall

    #jump to encrypt if 'e'
    beq $t0, 101, ENCRYPT
    #jump to decrypt if 'd'
    beq $t0, 100, DECRYPT    

 
ENCRYPT:
    jal getAddKey
    add $s0, $v0, $0      # save result to $s0
    jal toggleBit
    add $s1, $v0, $0      # save result to $s1
    jal prompt
    la  $s2, input  # save result to $s2
    
    la $t0, ($s0)   
    la $t1, ($s1) 
    la $t2, ($s2)  
    
    while:
    lb   $t3, 0($t2)        
    beq  $t3, 10, ENCRYPTED 
    add  $t3, $t3, $t0    # add addition key to character
    addi $t4, $0, 1       #generate 2^0
    sllv $t4, $t4, $t1    # slide to indicated bit
    xor  $t3, $t3, $t4    # toggle that bit
    sb   $t3, 0($t2)     
    addi $t2, $t2, 1      
    j while

     ENCRYPTED:
     li $v0, 4               
     la $a0, encryptOutput
     syscall
     la $a0, ($s2)
     syscall
     
    j EXIT
    
DECRYPT:
    jal getAddKey
    add $s0, $v0, $0      # save result to $s0
    jal toggleBit
    add $s1, $v0, $0      # save result to $s1
    jal prompt
    la  $s2, input  # save result to $s2
    
    la $t0, ($s0)   
    la $t1, ($s1)   
    la $t2, ($s2)  
    
    otherWhile:
    lb   $t3, 0($t2)         # load character
    beq  $t3, 10, DECRYPTED  # checks for line break
    
    addi $t4, $0, 1       # generate 2^0
    sllv $t4, $t4, $t1    #slide to inputed bit
    xor  $t3, $t3, $t4    # toggle that bit  
    sub  $t3, $t3, $t0    
    
    sb   $t3, 0($t2)      
    addi $t2, $t2, 1     
    j otherWhile

     DECRYPTED:
     li $v0, 4               # Print out decrypted text
     la $a0, decryptOutput
     syscall
     la $a0, ($s2)
     syscall
     
    j EXIT
    
# functions
getAddKey:
    li $v0, 4
    la $a0, Prompt_AddKey
    syscall  			# display prompt
    li $v0, 5
    syscall    			# read in int
    move $t1, $v0
    jr $ra

toggleBit:
    li $v0, 4
    la $a0, Prompt_ChooseBitToggle
    syscall    			# display prompt
    li $v0, 5
    syscall   			# read in int
    jr $ra

prompt:
    li $v0, 4
    la $a0, Prompt_AskForText
    syscall
    li $v0, 8
    la $a0, input
    lb $t0, 0($a0)
    li $a1, 48
    syscall
    jr $ra
    
EXIT:
    li $v0, 10
    syscall
