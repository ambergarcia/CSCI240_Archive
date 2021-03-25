#Amber Garcia
#Last Modified 12/15/19 10:38PM
#MIPS CODE: MIPS HW # 2 Recursion and Joke
#Editted with MARS 4.5

#Description: This program does two cases for the given assignment, checking only once for the value of k. 
# Whenever k is less than 1, or greater than 10 then the operation to shut down the program happens immediately.
# There is no loop to constantly ask for k, since that is only the requirement to check for case one or two.
# Now, comparing k to find case 1, which is to find if 1 < k < 5. When that is true, we will find the n value from the
# user. This will only occur when k is in that range. When k is greater than 5 and less than 10, we will print a joke.
# The joke isn't necessarily funny, but it's still a joke. Once we get a n value, we will attempt a recursion with the
# given value. Perform the operation 5*Func(n-2) + n until n is equal to zero or one. Finally, we will print the value
# for the user to see, and will ask for another integer n. This cycle will only end when n is less than 0.


#Pseudo Code:
#===================================================================================================
#int Func(int n){
#	if(n == 0 || n == 1){
#		return 20;
#	}else{
	
#		return 5*Func(n-2) + n;
#	}
#}
#===================================================================================================


.data

  ask_for_k: .asciiz "Please enter an integer between 1 and 10: "
  dead_end: .asciiz "Incorrect value, out of bounds. Ending program. \n Please run program again."
  ask_for_n: .asciiz "Please enter an integer greater than 1: "
  joke: .asciiz "Why is the firefly scared of the thunderbug? It was afraid that its glow attracted lightning! FUUUNNYYYY JOKE! "
  func_complete: .asciiz "Finished Recursion Answer is: "
  newline: .asciiz "\n"
  
.text
#===================================================================================================
.main:

# $t0 input 1 [k]
# $s0 input 2 [n]
# for slt, we will use these registers:

    li $a1, 1
    #to save commands, we will incriment a1 by 1,
    #until it reaches five for the rest of the program.
    li $a2, 10
    
    #for our decisions:
    li $a3, 0
#===================================================================================================

# Begin asking for k.

  what_input:

	#print prompt for k
  	la $a0, ask_for_k
  	li $v0, 4
  	syscall
  	#collect user input for k.
  	li $v0, 5
  	syscall
  	move $t0, $v0 #store input.
	
	#k is now in register $t0
	
  	#check if k is between 1 and 10.

  	slt $a3, $t0, $a1 #if input < 1, make it $a3 is 1
  	beq $a3, 1, incorrect_input
  
  	slt $a3, $t0, $a2 #if input > 10, make it $a3 is 0
  	beq $a3, 0, incorrect_input
	#if either one dont work, sends user to incorrect input. basically exits program easy
	j correct_input_k
#===================================================================================================

#Figure out if k goes into case 1 or 2.

  correct_input_k:
  	#a1 will be 5 to compare k for the case 1.
  	li $a1, 5
    #if k 1 <= k < 5
	slt $a3, $t0, $a1 #is k less than five, $a3 will be 1 if so. 
	beq $a3, 1, set_n  #since we already checked for 1 to be a correct k input, we only need to check
				#if k is less than five. k is forced to be greater or equal to 1.
	beq $a3, 0, display_joke
    #prompt user for n [>= 0]
#===================================================================================================

# Case 1, ask for n.

  set_n:
  	#n is register t1
  	#prompt for n
  	la $a0, ask_for_n
  	li $v0, 4
  	syscall
  	#catch user input
  	li $v0, 5
  	syscall
  	move $t1, $v0
  	
  	#We store n in $t1.
  	
  	slt $a3, $t1, $zero #if n is less than zero, set as 1.
  	beq $a3, $zero, function_n
  	#if less than zero just exit
  	j done
 #=================================================================================================== 	
 
 #Recursion segment.
 		
  function_n: 
  	
	li $t2, 5 #put 5 in t2
	#time to execute order 66
	
  	jal Func_n
  	#When done with the recursion, since the return will trace back to jal Func_n, we will print.
	j print_recursion
	Func_n:
		addi $sp, $sp, -8 #create space in sp for every loop.
		sw $ra, 0($sp) #Save return address.
		sw $t1, 4($sp) #Save n
		
		#Base case, when n==0 or n==1, jump to return_20 label. Found at the bottom of the code.
		beq $t1, $zero, return_20 
		beq $t1, 1, return_20 
			
		#Begin setting up the trace and function calling. Save n-2 in different addresses.
		addi $t1, $t1, -2 #n - 2
		jal Func_n
	
		#Begin process for 5 * fct(n-2) + n 
		lw $t1, 4($sp)
		
		#Here, we are using temporary registers [ $t3 and $t7 ]
		
		# $t3 to store 5*func(n-2).
		mul $t3, $v0, $t2 #note: v0 is Func(n-2)
		
		#$t7 to store the final process, 5 * Func(n-2) + n
		add $t7, $t3, $t1 
	
		#Store the final value to v0. v0 will be Func(n-2) for the next call.
		move $v0, $t7 
			
		#Epilogue
		finish_recursion: #Clean up stacks
			lw $t1, 4($sp) #get n address
			lw $ra, 0($sp) #get return address
			addi $sp, $sp, 8 #start deallocating 
		  
			jr $ra #return
		
#===================================================================================================

#Case 2, print a joke.

 display_joke:
 	#prints a very dull joke. jumps to done to exit.
 	la $a0, joke
 	li $v0, 4
 	syscall
 	j done
#===================================================================================================

#If k is the wrong input, exit.
		
 incorrect_input:
 #end program when k or n ain't good
    	la $a0, dead_end
    	li $v0, 4
    	syscall
    	j done
#===================================================================================================

#Print solely for the output on Recursion for the integer n. Go back to set_n.

print_recursion:
	move $s0, $v0 #gotta move the recursion value.
	#print prompt
	la $a0, func_complete
	li $v0, 4
	syscall
	#print value
	move $a0, $s0
	li $v0, 1
	syscall
	#newline
	la $a0, newline
	li $v0, 4
	syscall
	
	#time to go back.
	j set_n
#===================================================================================================
done:
 #ends program
   li $v0, 10
   syscall
#===================================================================================================

#For the recursion, placed at the bottom to prevent accidental errors.

return_20:
	#base value success, makes v0 20.
	#when it is returned, v0 will begin to
	#stack up all the other values as well.
	li $v0, 20
	j finish_recursion
