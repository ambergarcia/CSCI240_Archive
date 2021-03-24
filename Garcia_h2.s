#Amber Garica
#Last Modified 12/3/19 12:17AM
#MIPS CODE: Arrays [h2]
#Editted with MARS 4.5

#Description: Collects ten integers from the user and stores them into a label named hs_array,
#which initializes 10 elements in the label. Then, the program will calculate the sum value by
#adding all of the elements together. Right after, it will calculate the minimum value by continously
#comparing all of the integers in the array. Finally, this program will print the array in reverse order.

#Pseudo Code:
#================
#int hs_array[10];
#for(int i = 0; i < 9; i++){
#	cout << "Enter integer:"
#	cin >> x;
#	hs_array[i] = x;
#}
#cout << endl;
#int sum = 0;
#for(int k = 0; k < 9; k++){
#	sum += sum + hs_array[k];
#}
# cout << "Sum is: " << sum << endl;
# int min = hs_array[0];
#for(int j = 0; j < 9; j++){
# if(hs_array[j] < min){ 
#    min = hs_array[j];
# }
#}
# cout << "Min is: " << min << endl;
# cout << "----------------" << endl;
#for(int le = 9; le > 0; le++){
 # cout << hs_array[le] << endl;
 #}
 #cout << "----------------" << endl;
#================
.data
#all strings to print
  PROMPT1: .asciiz "Enter integer: "
  hs_array: .word 0:10
  #^ Create blank array with 0's inside, 10 elements.
  newline: .asciiz "\n"
  column_line: .asciiz "-------------------"
  print_sum: .asciiz "Sum is: "
  print_min: .asciiz "Minimum is: "
.text
main:
#--------------------------------------------------------------------------------------------	
	li $t0, 0 #start index
	li $t1, 9 #endloop
	li $t5, 0 #sum
	#load array address
	la $s5, hs_array #s5 base address of array
	
	initialize:
	#t0 start loop, t1 stop loop
		beq $t0, $t1, SUM_ARR #Jump to label when $t0 == 9
		
		#Prompts the user to enter 10 integer values that will represent the elements of an array.
		la $a0, PROMPT1
		li $v0, 4
		syscall
		#ask for int
		li $v0, 5
		syscall
		move $s0, $v0
		
		#store $s0 into hs_array
		#Populate the array with the given values.
		sw $s0, 0($s5)
		#store word s0 into next address s5
		addi $s5, $s5, 4 #Select next address
		addi $t0,$t0,1 #add 1 to index
		
		j initialize
#--------------------------------------------------------------------------------------------	
	#Compute and display the sum and min of these elements.
	SUM_ARR: la $s5, hs_array 
		 li $t0, 0
		#reset index and address
		# $t5 will be sum.
		sum_for: beq $t0, $t1, sum_print 
			lw $t4, 0($s5)
			
			add $t5, $t5, $t4 # $t5 <--- $t5 + $t4
			
			addi $s5, $s5, 4 #Select next address
			addi $t0,$t0,1 #Add 1 to index

			j sum_for
		
		sum_print: la $a0, print_sum #print the sum prompt
			   li $v0, 4
			   syscall
			
			   li $v0, 1
			   move $a0, $t5 #print the ACTUAL integer sum
			   syscall
			   
			   la $a0, newline #make a new line
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
			# $t4 < $t6 then $s0 == 1. Else: 0.
			slt $s0, $t4, $t6
			#beq sends system to label, changes $t6 <--- $t4 to set new min.
			beq $s0, 1, make_minimum
			back:
			#back is just to bring system back to min_for loop.
			addi $s5, $s5, 4 #Select next address
			addi $t0,$t0,1 #Increase index by 1
			
			j min_for
		
		min_print: la $a0, print_min #print min prompt
			   li $v0, 4
			   syscall
			
			   li $v0, 1
			   move $a0, $t6 #print ACTUAL integer min
			   syscall
			   
			   la $a0, newline #print newline string
			   li $v0, 4
			   syscall
#--------------------------------------------------------------------------------------------		
	#Traverses and display in reverse order the elements of the array on one column	
	REVERSE_COL:  la $s5, hs_array 
		      li $t0, 0
		#go to the end of the array
		reverse_first: beq $t0, $t1, display 
			#This reverse_first label goes to the last address of this array.
			addi $s5, $s5, 4 
			addi $t0,$t0,1 
			
			j reverse_first
		
		display: li $t0, 0
			addi $s5, $s5, -4 #the previous for loop makes it go out of bounds
			
			#Just printing a line
			la $a0, column_line
			li $v0, 4
			syscall
			#Just a next line call
			la $a0, newline
			li $v0, 4
			syscall
			
			#Prints array, starting at last value.	
			d_loop: beq $t0, $t1, END 
				lw $t4, 0($s5)
				
				#print value
				li $v0, 1
				move $a0, $t4
				syscall
				#newline
				la $a0, newline
				li $v0, 4
			 	syscall
				# -4 instead of +4 to go backwards, starting at 9.
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
 
 
