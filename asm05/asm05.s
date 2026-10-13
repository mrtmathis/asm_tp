global _start

section .data
	newline db 10

section .text
_start:
	mov rax, [rsp]
	cmp rax, 2
	jne _error

	mov rsi, [rsp + 16]

	mov rdx, 0
.len_loop:
	cmp byte [rsi + rdx], 0
	je .print_str
	inc rdx
	jmp .len_loop

.print_str:
	mov rax, 1
	mov rdi, 1
	syscall

	mov rax, 1
	mov rdi, 1
	mov rsi, newline
	mov rdx, 1
	syscall

	mov rax, 60
	mov rdi, 0
	syscall

_error:
	mov rax, 60
	mov rdi, 2
	syscall
