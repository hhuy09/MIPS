# Do An 2 MIPS
# Array
# 18120197 - Nguyen Dang Hong Huy
# 18120408 - Tran Ngoc Lan Khanh

.data
	.align 4
	array: .space 4000
	n: .word 0
	entern: .asciiz "Please enter the array size (0 < n < 1000) \nEnter n =  "
	reentern: .asciiz "Re-enter n = "
	enterelement: .asciiz "Enter elements of array \n"
	element: .asciiz "+ Element ["
	elementt: .asciiz "] = "
	printarr: .asciiz "List elements of array: "
	printmenu: .asciiz "======================MENU======================\n1. Export the elements.\n2. Sum the elements.\n3. List the elements as prime numbers.\n4. Find max.\n5. Find the element with the value x (the user entered) in the array.\n6. Exit the program"
	choosetype: .asciiz "\nChoose a feature to perform: "
	reentertype: .asciiz "Feature does not exist, please select again: "
	printsum: .asciiz "The sum of the elements: "
	printmax: .asciiz "Maximum value of the array: "
	printprime: .asciiz "List the elements as prime numbers: "
	enterx: .asciiz "Find the element with the value x\nEnter x = "
	nfound: .asciiz "Not found!"
	result: .asciiz "Result: "
	downline: .asciiz "\n"
	space: .asciiz " "
	elel: .asciiz "Element ["
	eler: .asciiz "]  "
	note: .asciiz "End Program"

#---------------------------------------------------------
#---------------------------------------------------------
.text
main:
	lw $a0, n
	jal _InputN
	sw $v0, n

	lw $a0, n
	la $a1, array
	jal _InputArray
	
	lw $a0, n
	jal _Menu

#---------------------------------------------------------
#---------------------------------------------------------	

# Menu	
_Menu:
	#-------------------------------------------------
	addi $sp, $sp, -8
	sw $ra, ($sp)
	sw $s0, 4($sp)
	
	#-------------------------------------------------
	la $a0, printmenu
	li $v0, 4	
	syscall

	_Menu.type:
		la $a0, choosetype
		li $v0, 4	
		syscall

	_Menu.do:	
		li $v0, 5	# Nhap type
		syscall
		move $s0, $v0
		blt $s0, 1, _Menu.redo		# n < 0 --> Nhap lai
		bgt $s0, 6, _Menu.redo	# n > 6 --> Nhap lai
		j _Menu.enddo

	_Menu.redo:	
		la $a0, reentertype
		li $v0, 4	# Xuat reentertype
		syscall
		j _Menu.do

	_Menu.enddo:
	
	beq $s0, 1, _Menu.1
	beq $s0, 2, _Menu.2
	beq $s0, 3, _Menu.3
	beq $s0, 4, _Menu.4
	beq $s0, 5, _Menu.5
	beq $s0, 6, _Menu.6

	_Menu.1: 
		lw $a0, n
		la $a1, array
		jal _PrintArray
		j _Menu.type

	_Menu.2:
		lw $a0, n
		la $a1, array
		jal _SumOfElements
		j _Menu.type

	_Menu.3:
		lw $a0, n
		la $a1, array
		jal _ListPrime
		j _Menu.type

	_Menu.4:
		lw $a0, n
		la $a1, array
		jal _FindMax
		j _Menu.type

	_Menu.5:
		lw $a0, n
		la $a1, array
		jal _FindX
		j _Menu.type

	_Menu.6:
		la $a0, note
		li $v0, 4	
		syscall
		li $v0, 10
		syscall

	#-------------------------------------------------
	sw $ra, ($sp)
	sw $s0, 4($sp)
	addi $sp, $sp, 8
	jr $ra

# Nhap so phan tu n
_InputN:
	#-------------------------------------------------
	addi $sp, $sp, -8
	sw $ra, ($sp)
	sw $s0, 4($sp)

	#-------------------------------------------------
	# Nhap so phan tu cua mang ( 0 < n < 1000 )
	_Inputn.do:
		la $a0, entern
		li $v0, 4	# Xuat entern
		syscall

	_Inputn.redo:	
		li $v0, 5	# Nhap n
		syscall
		move $a0, $v0
		move $s0, $v0
		blt $s0, 0, _Inputn.jump	# n < 0 --> Nhap lai
		bgt $s0, 1000, _Inputn.jump	# n > 1000 --> Nhap lai
		j _Inputn.enddo

	_Inputn.jump:
		la $a0, reentern
		li $v0, 4	# Xuat reentern
		syscall
		j _Inputn.redo

	_Inputn.enddo:

	#-------------------------------------------------
	lw $ra, ($sp)
	lw $s0, 4($sp)
	addi $sp, $sp, 8
	jr $ra

	_InputArray:
	#-------------------------------------------------
	addi $sp, $sp, -16
	sw $ra, ($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)

	#-------------------------------------------------
	move $s0, $a0 	# s0 = n
	li $s1, 0	# index
	move $s2, $a1
	la $a0, enterelement
	li $v0, 4	# Xuat enterelement
	syscall

	_InputArray.do:
		beq $s0, 0, _InputArray.enddo
		la $a0, element
		li $v0, 4	# Xuat element
		syscall
		move $a0, $s1
		li $v0, 1	
		syscall
		la $a0, elementt
		li $v0, 4	# Xuat elementt
		syscall
		li $v0, 5
		syscall
		sw $v0, ($s2)
		addi $s0, $s0, -1
		addi $s1, $s1, 1
		addi $s2, $s2, 4
		j _InputArray.do

	_InputArray.enddo:
	
	#-------------------------------------------------
	lw $ra, ($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $t0, 12($sp)
	addi $sp, $sp, 16
	jr $ra

# 1. Xuat cac phan tu
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
	addi $sp, $sp, 20
	jr $ra

# 2. Tinh tong cac phan tu
_SumOfElements:
	#-------------------------------------------------
	addi $sp, $sp, -20
	sw $ra, ($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)

	#-------------------------------------------------
	move $s0, $a0	# s0 = n
	li $s1, 0
	li $s2, 0	# Tong
	move $s3, $a1

	_SumOfElements.do:
		beq $s1, $s0, _SumOfElements.enddo
		lw $s4, ($s3)
		add $s2, $s2, $s4
		addi $s1, $s1, 1
		addi $s3, $s3, 4
		j _SumOfElements.do

	_SumOfElements.enddo:
		la $a0, printsum
		li $v0, 4	
		syscall
		move $a0, $s2
		li $v0, 1	
		syscall

	#-------------------------------------------------
	lw $ra, ($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	addi $sp, $sp, 20
	jr $ra

# 3. Liet ke cac phan tu la so nguyen to
_ListPrime:
	#-------------------------------------------------
	addi $sp, $sp, -32
	sw $ra, ($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)

	#-------------------------------------------------
	# In cac phan tu la SNT ra mang hinh, cach nhau boi khoang trang
	move $s0, $a0
	li $s1, 0	# index
	move $s2, $a1
	la $a0, printprime
	li $v0, 4	
	syscall
	
	_ListPrime.do:
		li $s5, 1
		li $s6, 0
		beq $s1, $s0, _ListPrime.enddo
		lw $s3, ($s2)
		addi $s4, $s3, 1

	_ListPrime.prime:
		beq $s5, $s4, _ListPrime.jump0
		div $s3, $s5
		mfhi $s7
		addi $s5, $s5, 1
		beq $s7, 0, _ListPrime.jump1
		j _ListPrime.prime

	_ListPrime.jump1:
		addi $s6, $s6, 1
		j _ListPrime.prime

	_ListPrime.jump0:
		beq $s6, 2, _ListPrime.jump2
		j _ListPrime.jump3

	_ListPrime.jump2:
		la $a0, elel
		li $v0, 4	
		syscall
		move $a0, $s1
		li $v0, 1	
		syscall
		la $a0, eler
		li $v0, 4	
		syscall
			
	_ListPrime.jump3:
		addi $s1, $s1, 1
		addi $s2, $s2, 4
		j _ListPrime.do
	
	_ListPrime.enddo:

	#-------------------------------------------------
	lw $ra, ($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	lw $s6, 24($sp)
	lw $s7, 28($sp)
	addi $sp, $sp, 32
	jr $ra

# 4. Tim Max
_FindMax: 
	#-------------------------------------------------
	addi $sp, $sp, -28
	sw $ra, ($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	sw $s5, 24($sp)
	
	#-------------------------------------------------
	move $s0, $a0
	li $s2, 0
	move $s3, $a1
	lw $s4, ($s3)
	move $s5, $s4	# Max = a[0]

	_FindMax.do:
		beq $s2, $s0, _FindMax.enddo
		lw $s4, ($s3)
		blt $s4, $s5, _FindMax.jump
		move $s5, $s4

	_FindMax.jump: 
		addi $s2, $s2, 1
		addi $s3, $s3, 4
		j _FindMax.do

	_FindMax.enddo:
		la $a0, printmax
		li $v0, 4	
		syscall
		move $a0, $s5
		li $v0, 1	
		syscall

	#-------------------------------------------------
	lw $ra, ($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	lw $s5, 24($sp)
	addi $sp, $sp, 28
	jr $ra

# 5. Tim phan tu x do nguoi dung nhap
_FindX:
	#-------------------------------------------------
	addi $sp, $sp, -24
	sw $ra, ($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	
	#-------------------------------------------------
	move $s0, $a0
	move $s1, $a1
	li $s2, 0
	li $s5, 0
	la $a0, enterx
	li $v0, 4	
	syscall
	li $v0, 5	# Nhap x
	syscall	
	move $s4, $v0	# s4 = x
	la $a0, result
	li $v0, 4
	syscall

	_FindX.do:
		beq $s2, $s0, _FindX.jump3
		lw $s3, ($s1)
		beq $s4, $s3, _FindX.jump0
		j _FindX.jump1

	_FindX.jump0:
		addi $s5, $s5, 1
		la $a0, elel
		li $v0, 4	
		syscall
		move $a0, $s2
		li $v0, 1	
		syscall
		la $a0, eler
		li $v0, 4	
		syscall

	_FindX.jump1:
		addi $s2, $s2, 1
		addi $s1, $s1, 4
		j _FindX.do

	_FindX.jump3:
		beq $s5, 0 , _FindX.jump2
		j _FindX.enddo
	
	_FindX.jump2:
		la $a0, nfound
		li $v0, 4	
		syscall

	_FindX.enddo:

	#-------------------------------------------------
	lw $ra, ($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	addi $sp, $sp, 24
	jr $ra
