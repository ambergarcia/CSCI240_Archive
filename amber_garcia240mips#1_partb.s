#Amber Garica
#Last Modified 12/2/19
#MIPS CODE: Section A
.data
  PROMPT1: .asciiz "Enter integer: "
  hs_array: .word 0:10
  newline: .asciiz "\n"
  column_line: .asciiz "-------------------"
  print_sum: .asciiz "Sum is: "
  print_min: .asciiz "Minimum is: "
  #make space in this array
.text
main:
	
	#make space in this array
		
#prompts the user to enter 10 integer values that will represent the elements of an array.
#Populate the array with the given values.
	#
#--------------------------------------------------------------------------------------------	
	li $t0, 0 #start index
	li $t1, 9 #endloop
	li $t5, 0 #sum
	#load array address
	la $s5, hs_array #s5 base address of array
	initialize:
	#t0 start, t1 stop
		beq $t0, $t1, SUM_ARR #when to stop
		
		#print prompt
		la $a0, PROMPT1
		li $v0, 4
		syscall
		#ask for int
		li $v0, 5
		syscall
		move $s0, $v0
		
		#store $s0 into hs_array
		
		sw $s0, 0($s5)
		#store word s0 into next address s5
		addi $s5, $s5, 4 #+4 equals the next address.
		addi $t0,$t0,1 #add 1 to index
		#goback up
		j initialize
#--------------------------------------------------------------------------------------------	
	#Compute and display the sum and min of these elements.
	SUM_ARR: la $s5, hs_array 
		 li $t0, 0
		#reset index and address
		#$t5 will be sum.
		sum_for: beq $t0, $t1, sum_print 
			lw $t4, 0($s5)
			
			add $t5, $t5, $t4 #add
			
			addi $s5, $s5, 4 
			#+4 equals the next address.
			addi $t0,$t0,1 
			#add 1 to index
			j sum_for
		
		sum_print: la $a0, print_sum
			   li $v0, 4
			   syscall
			
			   li $v0, 1
			   move $a0, $t5 #print sum
			   syscall
			   
			   la $a0, newline
			   li $v0, 4
			   syscall

#--------------------------------------------------------------------------------------------		
	MIN_ARR: la $s5, hs_array 
		 li $t0, 0
		#reset index and address
		# $t6 is min value
		 lw $t4, 0($s5)
		 move $t6, $t4
		min_for: beq $t0, $t1, min_print 
			lw $t4, 0($s5)
			# $s0 is comparison register
			slt $s0, $t4, $t6
			#beq sends system to label, changes $t6 <--- $t4 to set new min.
			beq $s0, 1, make_minimum
			back:
			#back is just to bring system back to min_for loop.
			addi $s5, $s5, 4 
			addi $t0,$t0,1 
			
			j min_for
		
		min_print: la $a0, print_min
			   li $v0, 4
			   syscall
			
			   li $v0, 1
			   move $a0, $t6 #print sum
			   syscall
			   
			   la $a0, newline
			   li $v0, 4
			   syscall
#--------------------------------------------------------------------------------------------		
	#Traverses and display in reverse order the elements of the array on one column	
	REVERSE_COL:  la $s5, hs_array 
		      li $t0, 0
		#go to the end of the array
		reverse_first: beq $t0, $t1, display 

			addi $s5, $s5, 4 
			addi $t0,$t0,1 
			
			j reverse_first
		
		display: li $t0, 0
			addi $s5, $s5, -4 #the previous for loop makes it go out of bounds
			
			la $a0, column_line
			li $v0, 4
			syscall
			
			la $a0, newline
			li $v0, 4
			syscall
			
			#just prints out the reverse array, starting from 9th pos 	
			d_loop: beq $t0, $t1, END 
				lw $t4, 0($s5)
		
				li $v0, 1
				move $a0, $t4
				syscall
				
				la $a0, newline
				li $v0, 4
			 	syscall
			
				addi $s5, $s5, -4 
				addi $t0,$t0,1 
				j d_loop

#--------------------------------------------------------------------------------------------		
	END:	
	#print out the last column_line
		la $a0, column_line
		li $v0, 4
		syscall
	#exit
		li $v0, 10
		syscall
#--------------------------------------------------------------------------------------------		
 	make_minimum:
 	#label used in min label
 		move $t6, $t4
 		j back
 
 
