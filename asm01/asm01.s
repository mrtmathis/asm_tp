global _start

section .data
	msg db 0x31, 0x33, 0x33, 0x37, 0x0A, 0x00

section .text
_start:
	mov rax, 1
	mov rdi, 0
	mov rsi, msg
	mov rdx, 6
	syscall
	

	mov rax, 60
	mov rdi, 0
	syscall
