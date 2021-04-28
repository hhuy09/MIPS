# Do An 2 MIPS
# Quick Sort
# 18120197 - Nguyen Dang Hong Huy
# 18120408 - Tran Ngoc Lan Khanh


.data
	file_input: .asciiz "D:\input_sort.txt"
	file_output: .asciiz "D:\output_sort.txt"
	outbuffer: .space 10000
	inbuffer: .space 10000
	.align 4
	array: .space 4000
	n: .word 0
	printarr: .asciiz "List elements of array: "
	space: .asciiz " "
	downline: .asciiz "\n"
	inputarray: .asciiz "Array was read from input_sort.txt\n"
	sorted: .asciiz "Array was successfully sorted by Quick Sort\n"
	
.text
.globl main
main:

	lw $a0, n
	la $a1, array
	jal _ReadFile
	sw $v0, n
	
	la $a0, inputarray
	li $v0, 4	
	syscall

	lw $a0, n
	la $a1, array
	jal _PrintArray

	la $t0, array 
	addi $a0, $t0, 0
	addi $a1, $zero, 0 
	lw $t0, n
	subi $t0, $t0, 1
	move $a2, $t0
	jal _QuickSort 

	lw $a1, n
	la $a0, array
	jal _WriteFile
	
	la $a0, downline
	li $v0, 4	
	syscall

	la $a0, sorted
	li $v0, 4	
	syscall

	lw $a0, n
	la $a1, array
	jal _PrintArray

	li $v0, 10
	syscall 

_ReadFile:
	#------------------------------------------------
	addi $sp, $sp, -32
	sw $ra, ($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $t1, 12($sp)
	sw $t2, 16($sp)
	sw $t3, 20($sp)
	sw $t4, 24($sp)
	#------------------------------------------------
	move $t1, $a0
	move $s1, $a1
	la $s0, inbuffer

	# Mo file
	li $v0, 13
	la $a0, file_input
	li $a1, 0
	li $a2, 0
	syscall
	move $s2, $v0
	# Doc file
	li $v0, 14
	move $a0, $s2
	la $a1, inbuffer
	li $a2, 10000
	syscall
	
	# Tim n
	li $t2, 10
	_ReadFile.FindN:
		lb $t0, ($s0)
		beq $t0, 13, _ReadFile.EndFindN
		mult $t1, $t2 
		mflo $t1
		add $t1, $t1, $t0
		addi $t1, $t1, -48   
		addi $s0, $s0, 1  
		j _ReadFile.FindN 
	_ReadFile.EndFindN:
	
	addi $s0, $s0, 2
	li $t0, 0

	# Lay Array
	la $s1, array
	li $t4, 10
	_ReadFile.Array:
		bge $t0, $t1, _ReadFile.End
		li $t2, 0
		_ReadFile.Parse:
			lb $t3, ($s0)
			beq $t3, 32, _ReadFile.EndParse
			beq $t3, $0, _ReadFile.EndParse
			beq $t3, 13, _ReadFile.EndParse
			mult $t2, $t4
			mflo $t2
			add $t2, $t2, $t3
			addi $t2, $t2, -48    
			addi $s0, $s0, 1
			j _ReadFile.Parse
		_ReadFile.EndParse:
		addi $s0, $s0, 1
		sw $t2, ($s1)  
		addi $s1, $s1, 4  
		addi $t0, $t0, 1
		j _ReadFile.Array
	_ReadFile.End:
	
	# Dong file
	li $v0, 16         		
    	move $a0, $s2     		
    	syscall

	move $v0, $t1
	#------------------------------------------------
	lw $ra, ($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $t2, 16($sp)
	lw $t3, 20($sp)
	lw $t4, 24($sp)
	addi $sp, $sp, 32
	jr $ra

_WriteFile:
	#------------------------------------------------
	add $sp, $sp, -12	# Initialize stack to save arguments
	sw $a0, 0($sp)		#$a0 store the array's address
	sw $a1, 4($sp)		#$sa1 store the size of the aray
	sw $ra, 8($sp)		# Store return address

	#------------------------------------------------
	move $s1, $a1		# store the size of the array back into $s1
	
	# Open file
	li $v0, 13		# System call: 13 = open file
	la $a0, file_output		# $a0 = name of file to write
	addi $a1, $0, 1		# $a1: Open for writing (flags are 0: read, 1: write)
	add $a2, $0, $0		# $a2: ignore mode = 0
	syscall			# Open File, $v0<-fd (file descriptor)
	add $s2, $v0, $0		# Store the return value in $s2

	# Print 
	li $t1, 0		# $t1 = i = 0
	LoopPrint:
	lw $a0, 0($sp)		# Load array address back to $a0
		
	beq $t1, $s1, EndPrint	# if (i == array_size) break; 
		
	sll $t2, $t1, 2		# $t2 = i * 4
	add $t2, $a0, $t2	# $t2 = array + 4*i
	lw $s3, 0($t2)		# $s3 = array[i]

	la $a0, array 	#$a0 store the array's address argument
	add $a1, $zero, $s3 #store array[i] 
	jal IntToString
	
	move $t7, $v0 #store the return value in $v0 into $t7
	move $t8, $v1 #store the return value in $v1 into $t8
		
	add $t1, $t1, 1		# i++
		
	# Print number to file
	li $v0, 15   			# System call for write to file
	move $a0, $s2    		# File descriptor 
	move $a1, $t7   		# Address of buffer from which to write
	li $a2, 0
	add $a2, $a2, $t8       	# Buffer length
	syscall 			# Write to file
		
	j LoopPrint	
		
IntToString:
	#------------------------------------------------
	add $sp, $sp, -8

	sw $a0, 0($sp)		#store the address of the array into stack
	sw $a1, 4($sp) 		#store array[i] into stack

	lw $t3, 0($sp)		#pop stack and store the address of the array into $t3
	lw $s3, 4($sp)		#pop stack and store the value of array at index i into $s3
	li $t4, 0			#initialize the buffer length
	
	Loop:
	sub $t3, $t3, 1				# Move $t3 to next digit
	
	add $t5, $0, 10				#$t5 = 10
	div $s3, $t5				#$s3 / $t5
	mflo $s3				# $s3 holds new value after being divided (Quotient)
	mfhi $t5				# $t5 holds Remainder (number to convert)
	
	add $t5, $t5, '0'			# Change digit into ASCII code
	sb $t5, ($t3)				# Push that string into $t3 (buffer)
	
	addi $t4, $t4, 1			# number of digits ++ - buffer length

	bne $s3, $0, Loop		# if not finish that number, loop
	
	beq $t1, 0, ReturnValue	# if it is the first number of array, do not add backspace

	# Add backspace
	sub $t3, $t3, 1
	add $t5, $0, 32
	sb $t5, ($t3)
	addi $t4, $t4, 1

	ReturnValue:
	move $v0, $t3 # $v0 store the address of buffer
	move $v1, $t4 #store the buffer length
	
	IntToStringDone:

	#------------------------------------------------
	addi $sp, $sp, 8
	jr $ra			# Jump back to caller

	EndPrint:
	# Close file
	li 	$v0, 16 		# System call: 16 = open file 
 	move 	$a0, $s0		# Copy file descriptor to argument
 	syscall 			# Close file
 	
	lw $a0, 0($sp)		# Load argurment saved in stack back to register 
	lw $s1, 4($sp)		
	lw $ra, 8($sp)
	add $sp, $sp, 12		# Free stack
	jr $ra			# Jump back to caller

	
_PrintArray:
	#-------------------------------------------------
	addi $sp, $sp, -20
	sw $ra, ($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)

	#-------------------------------------------------
	move $s0, $a0
	li $s1, 0
	move $s2, $a1
	la $a0, printarr
	li $v0, 4	
	syscall

	_PrintArray.do:
		beq $s1, $s0, _PrintArray.enddo
		lw $s3, ($s2)
		move $a0, $s3
		li $v0, 1	
		syscall
		la $a0, space
		li $v0, 4	
		syscall
		addi $s1, $s1, 1
		addi $s2, $s2, 4
		j _PrintArray.do

	_PrintArray.enddo:
	
	#-------------------------------------------------
	lw $ra, ($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	addi $sp, $sp, 16
	jr $ra

_Swap:
	#-------------------------------------------------
	add $sp, $sp, -12

	sw $a0, 0($sp)		#luu $a0
	sw $a1, 4($sp) 		#luu $a1
	sw $a2, 8($sp) 		#luu $a2

	#-------------------------------------------------
	sll $t1, $a1, 2 	#t1 = 4a
	add $t1, $a0, $t1 	#t1 = array + 4a
	lw $s5, 0($t1) 		#s3 t = array[a]

	sll $t2, $a2, 2 	#t2 = 4b
	add $t2, $a0, $t2 	#t2 = array + 4b
	lw $s6, 0($t2)		#s4 t = array[b]

	#-------------------------------------------------
	sw $s6, 0($t1) 		#array[b] = array[a]
	sw $s5, 0($t2) 		#array[a] = t

	addi $sp, $sp, 12	#Restoring the stack size
	jr $ra			#jump back to the caller

_QuickSort:
	#-------------------------------------------------
	addi $sp, $sp, -24

	sw $s0, 0($sp)		#store a0 - array address
	sw $s1, 4($sp)		#store a1 - left
	sw $s2, 8($sp)		#store a2 - right
	sw $a1, 12($sp)		#store left
	sw $a2, 16($sp)		#store right
	sw $ra, 20($sp)		#store ra

	#-------------------------------------------------
	bgt $a1, $a2, return    #if (l > r) return;

	move $s0, $a1		#s0 iLeft = left
	move $s1, $a2		#s1 iRight = right

	sub $t0, $s1, $s0 	#t0 = right - left
	li $t1, 2
	div $t0, $t1 
	mflo $t0	 	# t0 = (right - left) /2
	add $t0, $t0, $s0 	#t0 = left + (right - left) / 2
	sll $t0, $t0, 2		# t0 = 4*pivot
	add $t0, $a0, $t0	# t0 = arr + 4*pivot
	lw $s2, 0($t0)		# s2 = arr[pivot]

	loop: 
	bgt $s0, $s1, exit_loop #iLeft > iRight dung ->  thoat_lap

	loop1:

	sll $t2, $s0, 2		# t2 = 4*iLeft
	add $t2, $a0, $t2	# t2 = arr + 4*iLeft
	lw $t3, 0($t2)		# t3 = arr[iLeft]

	bge $t3, $s2, exit_loop1 # (arr[iLeft] >= pivot) -> thoat vong lap
	addi $s0, $s0, 1 	#iLeft++
	j loop1

	exit_loop1:

	loop2:

	sll $t2, $s1, 2		# t2 = 4*iRight
	add $t2, $a0, $t2	# t2 = arr + 4*iRight
	lw $t3, 0($t2)		# t3 = arr[iRight]

	ble $t3, $s2, exit_loop2 #(arr[iRight] <= pivot) -> thoat vong lap
	subi $s1, $s1, 1 	#iRight--
	j loop2

	exit_loop2:

	ble $s0, $s1, if_statement

	j loop
	exit_loop:

	blt $a1, $s1, quickSort_recursion_1 # ìf(left < iRight)
	j if_statement_1
	quickSort_recursion_1: #quickSort(arr, left, iRight)
	move $a2, $s1 		#a2 = iRight
	jal _QuickSort		#call quicksort

	# pop stack
	lw $a1, 12($sp)		# load a1
	lw $a2, 16($sp)		# load a2
	lw $ra, 20($sp)		# load ra
	
	if_statement_1:
	blt $s0, $a2, quickSort_recursion_2 # ìf(iLeft < right)
	quickSort_recursion_2: #quickSort(arr, iLeft, right)
	move $a1, $s0		#a1 = iLeft			
	jal _QuickSort		#call quicksort

	# pop stack
	lw $a1, 12($sp)		#load a1
	lw $a2, 16($sp)		#load a2
	lw $ra, 20($sp)		#load ra

	j return

	if_statement:
	move $a1, $s0		#a1 = i
	move $a2, $s1		#a2 = j
	jal _Swap		#swap(arr, i, j)
	lw $a1, 12($sp)		# load a1
	lw $a2, 16($sp)		# load a2
	addi $s0, $s0, 1
	subi $s1, $s1, 1

	j loop

	return:

	#-------------------------------------------------
	lw $s0, 0($sp)		#restore a0
	lw $s1, 4($sp)		#restore a1
	lw $s2, 8($sp)		#restore a2
	addi $sp, $sp, 24	#restore the stack
	jr $ra			#return to caller

