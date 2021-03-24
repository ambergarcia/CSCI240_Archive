#Amber Garica
#Last Modified 12/3/19 12:17AM
#MIPS CODE: While loops and decisions with SLT [h1]
#Editted with MARS 4.5

#Description: This program performs two while loops, one to keep a fixed preferable range for the
# two integers being set and another to establish the sentinel values to allow the user to leave the program.
# The program then calculates a specific sum, four * integer 1 plus seven * ( integer 2 minus 9 ). It will
# print the final sum, and will loop all the way back to the requests for integers. 

#Pseudo Code:
#================
#int main(){
# int int1 = 0, int2 = 0;
# int sum = 0;
# while(int1 != 999 || int2 != 999){
#	while((int1 >= 100 && int1 <= 250) && (int2 == -31)){
#		cout << "Please enter first int greater than 100 and less than 250: ";
#		cin >> int1; cout << endl;
#		cout << "Please enter second int greater than -30: "
# 		cin >> int2; cout << endl;
#		if( int1 == 999 || int2 == 999){return 0;}
#	}
#	
#	sum = 4*int1+ 7*(int2 -9);
#	cout << "Sum is: " << sum << endl;
#}
# return 0;
# }
#================


.data
  PROMPT1: .asciiz "Please enter first integer greater than 100 and less than 250: "
  PROMPT2: .asciiz "Please enter a second integer greater than -30: "
  newline: .asciiz "\n"
.text
main:

#Initialize Variables
	
	li $s5, 999 #sentinel
	li $t0, 100 #range for int1
	li $t1, 250 #range for int1 again
	li $t2, -30 #range for int2
	li $t5, 7 

#Prompts the user to enter a first integer (int1) in the range [100, 250]
	sys_loopcall1:
		#print prompt 1
		la $a0, PROMPT1
		li $v0, 4
		syscall
		
		#ask for int1
		li $v0, 5
		syscall
		move $s0, $v0
		
		#check for sentinel == 999
		beq $s5, $s0, DONE
		slt $s2, $s0, $t0
		
		#Check for range >= 100
		beq $s2, 1, sys_loopcall1
		#Check for range <= 250
		slt $s3, $s0, $t1
		beq $s3, 0, sys_loopcall1
	sys_loopcall2:
		#print prompt 2
		la $a0, PROMPT2
		li $v0, 4
		syscall
		
		#ask for int2
		li $v0, 5
		syscall
		move $s1, $v0
		
		#check for sentinel == 999
		beq $s5, $s1, DONE
		#check for range > -30
		slt $s4, $s1, $t2
		beq $s4, 1, sys_loopcall2
 
#Compute: 4*int1+ 7*(int2 -9) // don’t use subi; don’t use muli

	compute_problem:
	
		#$t3 = 4*s0
		sll $t3, $s0, 2
		#sll r1, r2, n [r2*2^n] --> r1
		
		#compute_sub_int2_9:
	        addi $t4, $s1, -9 #$t4 = s1 + -9
	        
		#compute_multi_7times_subtotal:
		
		mul $t6, $t4, $t5 #$t5 = 7  #$t6 = t4*t5
		
		#compute_add_sum1andsum2:
		add $t7, $t3, $t6 # $t7 is the final number
	PRINT:
		#prints the final number
		move $a0, $t7
		li $v0, 1
		syscall
		#go back to the previous loop to find new numbers. Only ends if sentinel is found
		
		la $a0, newline #make a new line
		li $v0, 4
		syscall
		
		j sys_loopcall1
	DONE:
		#when sentinel is activated, closes program
		li $v0, 10
		syscall
