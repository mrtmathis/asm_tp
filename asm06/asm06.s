global _start

section .bss
	buffer resb 32

section .text
_start:
	mov rax, [rsp]
	cmp rax, 3
	jne _error2

	mov rsi, [rsp + 16]
	call parse_num
	mov r12, rax

	mov rsi, [rsp + 24]
	call parse_num
	mov r13, rax

	add r12, r13
	jo _error1

	mov rax, r12
	call print_num

	mov rax, 60
	mov rdi, 0
	syscall

parse_num:
	xor rax, rax
	xor r8, r8
	xor rdx, rdx

	mov cl, byte [rsi]
	cmp cl, '-'
	je .is_neg
	cmp cl, '+'
	je .is_pos
	jmp .loop

.is_neg:
	mov r8, 1
	inc rsi
	jmp .loop

.is_pos:
	inc rsi

.loop:
	movzx rcx, byte [rsi]
	test rcx, rcx
	jz .done

	cmp rcx, '0'
	jl _error1
	cmp rcx, '9'
	jg _error1

	sub rcx, '0'
	inc rdx

	imul rax, 10
	jo _error1

	test r8, r8
	jnz .sub_digit

	add rax, rcx
	jo _error1
	jmp .next

.sub_digit:
	sub rax, rcx
	jo _error1

.next:
	inc rsi
	jmp .loop

.done:
	cmp rdx, 0
	je _error1
	ret

print_num:
	mov rsi, buffer + 31
	mov byte [rsi], 10

	mov r8, rax
	mov r9, 10

	test rax, rax
	jns .convert
	neg rax

.convert:
	dec rsi
	xor rdx, rdx
	div r9
	add dl, '0'
	mov [rsi], dl
	test rax, rax
	jnz .convert

	test r8, r8
	jns .print
	dec rsi
	mov byte [rsi], '-'

.print:
	mov rdx, buffer + 32
	sub rdx, rsi

	mov rax, 1
	mov rdi, 1
	syscall
	ret

_error1:
	mov rax, 60
	mov rdi, 1
	syscall

_error2:
	mov rax, 60
	mov rdi, 2
	syscall

