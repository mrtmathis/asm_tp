global _start

section .bss
	buffer resb 80

section .data
	hex_digits db "0123456789ABCDEF"

section .text
_start:
	mov rax, [rsp]
	cmp rax, 2
	je .hex_mode
	cmp rax, 3
	je .check_flag
	jmp _error2

.hex_mode:
	mov rsi, [rsp + 16]
	cmp byte [rsi], '-'
	jne .set_hex
	cmp byte [rsi + 1], 'b'
	jne .set_hex
	cmp byte [rsi + 2], 0
	je _error2

.set_hex:
	mov r12, 4
	mov r13, 15
	jmp .parse

.check_flag:
	mov rsi, [rsp + 16]
	cmp byte [rsi], '-'
	jne _error2
	cmp byte [rsi + 1], 'b'
	jne _error2
	cmp byte [rsi + 2], 0
	jne _error2

	mov r12, 1
	mov r13, 1
	mov rsi, [rsp + 24]

.parse:
	call parse_num
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
	mov rsi, buffer + 79
	mov byte [rsi], 10

	mov r8, rax
	test rax, rax
	jns .convert
	neg rax

.convert:
	dec rsi
	mov rdx, rax
	and rdx, r13
	mov dl, byte [hex_digits + rdx]
	mov [rsi], dl
	mov rcx, r12
	shr rax, cl
	test rax, rax
	jnz .convert

	test r8, r8
	jns .print
	dec rsi
	mov byte [rsi], '-'

.print:
	mov rdx, buffer + 80
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
