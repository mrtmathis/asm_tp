global _start

section .bss
	header resb 64

section .text
_start:
	mov rax, [rsp]
	cmp rax, 2
	jne _error2

	mov rax, 2
	mov rdi, [rsp + 16]
	mov rsi, 0
	syscall

	cmp rax, 0
	jl _error2
	mov r12, rax

	mov rax, 0
	mov rdi, r12
	mov rsi, header
	mov rdx, 64
	syscall

	cmp rax, 0
	jl _error2
	mov r13, rax

	mov rax, 3
	mov rdi, r12
	syscall

	cmp r13, 20
	jl _not_elf

	cmp byte [header], 0x7F
	jne _not_elf
	cmp byte [header + 1], 'E'
	jne _not_elf
	cmp byte [header + 2], 'L'
	jne _not_elf
	cmp byte [header + 3], 'F'
	jne _not_elf

	cmp byte [header + 4], 2
	jne _not_elf

	cmp byte [header + 5], 1
	jne _not_elf

	cmp byte [header + 6], 1
	jne _not_elf

	cmp word [header + 18], 0x3E
	jne _not_elf

	mov rax, 60
	mov rdi, 0
	syscall

_not_elf:
	mov rax, 60
	mov rdi, 1
	syscall

_error2:
	mov rax, 60
	mov rdi, 2
	syscall
