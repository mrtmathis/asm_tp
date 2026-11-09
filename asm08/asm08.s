global _start

section .bss
	output resb 32

section .text
_start:
	mov rax, [rsp]
	cmp rax, 2
	jne _wrong_args

	mov rsi, [rsp + 16]
	xor rdx, rdx
	xor rbx, rbx
	xor r9, r9
	mov al, byte [rsi]
	cmp al, '-'
	je .negative
	cmp al, '+'
	je .has_sign
	jmp .parse_loop	

.negative:
	mov r9, 1

.has_sign:
	inc rsi	

.parse_loop:
	mov al, byte [rsi]
	cmp al, 0
	je .check_result

	cmp al, '0'
	jl _not_a_number
	cmp al, '9'
	jg _not_a_number

	sub al, '0'
	movzx r8, al
	imul rbx, rbx, 10
	jo _not_a_number
	add rbx, r8
	jo _not_a_number

	inc rdx
	inc rsi	
	jmp .parse_loop

.check_result:
	cmp rdx, 0
	je _not_a_number

	xor rax, rax
	cmp r9, 1
	je _print
	cmp rbx, 1
	jle _print

	mov rax, rbx
	lea rcx, [rbx - 1]
	test rax, 1
	jz .half_n
	shr rcx, 1
	jmp .multiply

.half_n:
	shr rax, 1

.multiply:
	mul rcx	

_print:
	mov rdi, output + 31
	mov byte [rdi], 10
	mov rcx, 10

.convert_loop:
	xor rdx, rdx
	div rcx	
	add dl, '0'
	dec rdi
	mov [rdi], dl
	cmp rax, 0
	jne .convert_loop

	mov rsi, rdi
	mov rdx, output + 32
	sub rdx, rdi
	mov rax, 1
	mov rdi, 1
	syscall

	mov rax, 60
	mov rdi, 0
	syscall

_not_a_number:
	mov rax, 60
	mov rdi, 1
	syscall

_wrong_args:
	mov rax, 60
	mov rdi, 2
	syscall
