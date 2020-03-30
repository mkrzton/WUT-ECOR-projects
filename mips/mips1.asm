.eqv BYTES_PER_ROW 960
.eqv width 320
.eqv height 240

.data

res: .space 2
image: .space 54
path: .asciiz "s05-2.bmp"

shape1: .asciiz "Shape 1 detected - L shape\n"
shape2: .asciiz "Shape 2 detected - T shape\n"
no_shape: .asciiz "No Shape has been detected\n"
corner_number: .asciiz "Number of Corners: "
bitmap_error_message: .asciiz "File path does not lead to bitmap.\n"
size_error_message: .asciiz "File size is incorrect.\n"
path_error_message: .asciiz "File path is incorrect.\n"

.text

main:
   
    	#clearing registers
	xor $s0, $s0, $s0 
	xor $s1, $s1, $s1 
	xor $s2, $s2, $s2 
	xor $t0, $t0, $t0
	xor $t1, $t1, $t1 
	xor $t2, $t2, $t2 
	xor $t3, $t3, $t3 
	xor $t4, $t4, $t4 
	xor $t5, $t5, $t5 
	xor $t6, $t6, $t6 

	#open file
	li $v0, 13
	la $a0, path 
	li $a1, 0 
	li $a2, 0 
	syscall

	move $s0, $v0      
	blez $s0, path_error

	#read data from file header
	li $v0, 14
	move $a0, $s0
	la $a1, image
	li $a2, 54
	syscall

	li $t0, 0x4D42 
	la $t1, image
	lhu $t2, ($t1) 
	bne $t0, $t2, bitmap_error  

	li $t0, width
	la $t1, image + 18 #read the file width from the header
	lw $t2, ($t1)
	bne $t0, $t2, size_error

	#check if height is correct
	li $t0, height
	la $t1, image + 22 
	lw $t2, ($t1)
	bne $t0, $t2, size_error

	#store size of image data in bytes	
	la $t1, image + 34
	lw $t2, ($t1)
	move $s2, $t2

	#read image data into array
	li $v0, 9 
	syscall
	move $s1, $v0

	li $v0, 14
	move $a0, $s0 
	move $a1, $s1 
	move $a2, $s2 
	syscall

	li $v0, 16
	move $a0, $s0
	syscall

	xor $t0, $t0, $t0
	xor $t1, $t1, $t1
	xor $t2, $t2, $t2

	li $t1, BYTES_PER_ROW
	move $t2, $s1
	move $t3, $s2 
	sub $t3, $t3, 3
	sub $t3, $t3, $t1

top_left_pixel:

	add $t2, $t2, $t1
	lb $t0, 0($t2)

	beqz $t0, top_right_pixel 
	jal white_pixel_counter

top_right_pixel:

	add $t2, $t2, 3   
	lb $t0, 0($t2)

	beqz $t0, bottom_left_pixel
	jal white_pixel_counter

bottom_left_pixel:

	sub $t2, $t2, 3
	sub $t2, $t2, $t1
	lb $t0, 0($t2)

	beqz $t0, bottom_right_pixel
	jal white_pixel_counter

bottom_right_pixel:

	add $t2, $t2, 3
	lb $t0, 0($t2)
	sub $t2, $t2, 3

	beqz $t0, corner_counter 
	jal white_pixel_counter

corner_counter:

	bne $t4, 1, move_to_next_pixel 
	addi $t5, $t5, 1

	jal new_line
       
        li $v0, 4
	la $a0, corner_number 
	syscall

	li $v0, 1
	la $a0, ($t5)
	syscall
       
move_to_next_pixel:

	li $t4, 0 
	addi $t2, $t2, 3 
	addi $t6, $t6, 3

	ble $t3, $t6, T_shape 
	j top_left_pixel

T_shape:

	blt $t5, 5, empty 
	blt $t5, 6, L_shape 

	jal new_line

	li $v0, 4 
	la $a0, shape2
	syscall

	j end

L_shape:

	jal new_line

	li $v0, 4
	la $a0, shape1
	syscall
	
	j end

empty:
	jal new_line
	
	li $v0, 4
	la $a0, no_shape
	syscall


end:

	li $v0, 10
	syscall


new_line:

	addi $a0, $0, 0xA
        addi $v0, $0, 0xB
        syscall
       
        jr $ra
       
white_pixel_counter:

	addi $t4, $t4, 1
	jr $ra

path_error:

	li $v0, 4
	la $a0, path_error_message
	syscall

	j end

size_error:

	li $v0, 4
	la $a0, size_error_message
	syscall

	j end


bitmap_error:

	li $v0, 4
	la $a0, bitmap_error_message
	syscall

	j end
