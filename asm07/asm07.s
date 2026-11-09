global _start

section .bss
	input resb 256

section .text
_start:
	mov rax, 0
	mov rdi, 0
	mov rsi, input
	mov rdx, 256
	syscall

	cmp rax, 0
	jle _not_a_number

	mov rcx, rax
	mov rsi, input
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
	dec rcx
	jz _not_a_number

.parse_loop:
	cmp rcx, 0
	je .check_result

	mov al, byte [rsi]

	cmp al, 10
	je .check_result
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
	dec rcx
	jmp .parse_loop

.check_result:
	cmp rdx, 0
	je _not_a_number

	cmp r9, 1
	je _not_prime

	cmp rbx, 2
	jl _not_prime
	je _prime

	test rbx, 1
	jz _not_prime

	mov rdi, 3

.div_loop:
	mov rax, rbx
	xor rdx, rdx
	div rdi	
	cmp rdi, rax
	ja _prime
	cmp rdx, 0
	je _not_prime
	add rdi, 2
	jmp .div_loop

_prime:
	mov rax, 60
	mov rdi, 0
	syscall

_not_prime:
	mov rax, 60
	mov rdi, 1
	syscall

_not_a_number:
	mov rax, 60
	mov rdi, 2
	syscall
