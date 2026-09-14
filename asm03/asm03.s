global _start

section .data
	msg db 0X31, 0x33, 0x33, 0x37, 0x0A

section .text
_start:
	cmp qword [rsp], 2
	jne _error

	mov rsi, [rsp + 16]

	cmp byte [rsi], 0x34
	jne _error

	cmp byte [rsi + 1], 0x32
	jne _error

	cmp byte [rsi + 2], 0x00
	jne _error

	mov rax, 1
	mov rdi, 1
	mov rsi, msg
	mov rdx, 5
	syscall

	mov rax, 60
	mov rdi, 0
	syscall

_error:
	mov rax, 60
	mov rdi, 1
	syscall
