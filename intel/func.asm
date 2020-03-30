global shape_Detection

shape_Detection:

push    ebp 
mov     ebp, esp 
       
push	ecx	
push	edx	
push    edi	
push 	esi 	
	
mov     edi, [ebp+8]
add	edx, 1

look_for_black_frame: 
 
cmp	BYTE [edi], 0 				
je	black_pixel_found	
add	edx, 1		
add	edi, 3
jmp	look_for_black_frame

black_pixel_found:

mov	esi, edi	
mov	edx, 1	

count_width_of_black_frame:

cmp	BYTE [edi], 0 
jne	detection
add	edx, 1
add	edi, 3
jmp	count_width_of_black_frame

detection:

sub	edx, 1	
mov	ecx, edx 	
mov	edx, 1		
mov	edi, esi	
add	edi, 960	

start_looking_for_white_pixel:

cmp	edx, ecx 	
je	go_to_next_row 	
cmp	BYTE [edi], 0 
jne	go_to_previous_row
add	edx, 1
add	edi,3
jmp	start_looking_for_white_pixel

go_to_next_row:

mov	edx,1
mov	edi, esi
add	edi, 960
mov	esi, edi
jmp	start_looking_for_white_pixel

go_to_previous_row:

sub	edi,3

which_shape:

cmp	BYTE [edi], 0 
jne	L_shape
add	edi, 3
cmp	BYTE [edi], 0 
je	T_shape
sub	edi, 3
add	edi, 960
jmp	which_shape

no_shape:

mov	eax, 0
jmp 	end

L_shape:

mov	eax, 1
jmp	end

T_shape:

mov	eax, 2
	
end:

pop	ecx
pop	edx
pop     edi
pop 	esi
	
mov     esp, ebp	
pop     ebp
ret
