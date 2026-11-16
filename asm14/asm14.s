global _start

section .data
	msg db "Hello Universe!", 10
	msg_len equ $ - msg

section .text
_start:
	mov rax, [rsp]
	cmp rax, 2
	jne _error2

	mov rax, 2
	mov rdi, [rsp + 16]
	mov rsi, 0x241
	mov rdx, 0644o
	syscall

	cmp rax, 0
	jl _error1
	mov r12, rax

	mov rax, 1
	mov rdi, r12
	mov rsi, msg
	mov rdx, msg_len
	syscall

	cmp rax, msg_len
	jne _error1

	mov rax, 3
	mov rdi, r12
	syscall

	mov rax, 60
	mov rdi, 0
	syscall

_error1:
	mov rax, 60
	mov rdi, 1
	syscall

_error2:
	mov rax, 60
	mov rdi, 2
	syscall
