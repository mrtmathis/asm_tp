global _start

section .bss
	input resb 4096
	output resb 4097

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
	jz .print
	cmp byte [input + r12 - 1], 10
	jne .reverse
	dec r12

.reverse:
	lea rsi, [input + r12]
	mov rdi, output
	mov rcx, r12
	test rcx, rcx
	jz .print

.reverse_loop:
	dec rsi
	mov al, byte [rsi]
	mov [rdi], al
	inc rdi
	dec rcx
	jnz .reverse_loop

.print:
	mov byte [output + r12], 10

	mov rax, 1
	mov rdi, 1
	mov rsi, output
	lea rdx, [r12 + 1]
	syscall

	mov rax, 60
	mov rdi, 0
	syscall
