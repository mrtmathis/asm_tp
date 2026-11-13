global _start

section .bss
	input resb 4096

section .text
_start:
	xor r12, r12

.read_loop:
	mov rax, 0
	mov rdi, 0
	lea rsi, [input + r12]
	mov rdx, 4096
	sub rdx, r12
	jz .strip_newline
	syscall

	cmp rax, 0
	jle .strip_newline
	add r12, rax
	jmp .read_loop

.strip_newline:
	test r12, r12
	jz _palindrome
	cmp byte [input + r12 - 1], 10
	jne .check
	dec r12

.check:
	mov rsi, input
	lea rdi, [input + r12 - 1]

.check_loop:
	cmp rsi, rdi
	jge _palindrome

	mov al, byte [rsi]
	cmp al, byte [rdi]
	jne _not_palindrome

	inc rsi
	dec rdi
	jmp .check_loop

_palindrome:
	mov rax, 60
	mov rdi, 0
	syscall

_not_palindrome:
	mov rax, 60
	mov rdi, 1
	syscall
