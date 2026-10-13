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
	xor r8, r8
	mov al, byte [rsi]
	cmp al, '-'
	je .has_sign
	cmp al, '+'
	je .has_sign
	jmp .parse_loop

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

	mov r8b, al 
	inc rdx 
	inc rsi
	dec rcx
	jmp .parse_loop

.check_result:
	cmp rdx, 0
	je _not_a_number

	and r8b, 1
	cmp r8b, 0
	je _even

_odd:
	mov rax, 60
	mov rdi, 1
	syscall

_even:
	mov rax, 60
	mov rdi, 0
	syscall

_not_a_number:
	mov rax, 60
	mov rdi, 2
	syscall

