global _start

section .data
	patch db "H4CK"

section .bss
	buffer resb 1048576

section .text
_start:
	mov rax, [rsp]
	cmp rax, 2
	jne _error2

	mov rax, 2
	mov rdi, [rsp + 16]
	mov rsi, 2
	syscall

	cmp rax, 0
	jl _error1
	mov r12, rax

	xor r13, r13

.read_loop:
	mov rax, 0
	mov rdi, r12
	lea rsi, [buffer + r13]
	mov rdx, 1048576
	sub rdx, r13
	jz .search
	syscall

	cmp rax, 0
	jl _error1
	je .search
	add r13, rax
	jmp .read_loop

.search:
	xor rbx, rbx

.search_loop:
	lea rax, [rbx + 5]
	cmp rax, r13
	jg _error1

	cmp dword [buffer + rbx], 0x37333331
	jne .next
	cmp byte [buffer + rbx + 4], 10
	je .found

.next:
	inc rbx
	jmp .search_loop

.found:
	mov rax, 18
	mov rdi, r12
	mov rsi, patch
	mov rdx, 4
	mov r10, rbx
	syscall

	cmp rax, 4
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
