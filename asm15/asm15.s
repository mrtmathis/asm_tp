global _start

section .bss
	input resb 4096

section .text
_start:
	mov rax, [rsp]
	cmp rax, 2
	jne _error2

	mov rsi, [rsp + 16]
	call parse_num

	cqo
	mov rcx, 26
	idiv rcx
	mov r12, rdx
	test r12, r12
	jns .read_loop
	add r12, 26

.read_loop:
	mov rax, 0
	mov rdi, 0
	mov rsi, input
	mov rdx, 4096
	syscall

	cmp rax, 0
	jle .done

	mov r13, rax
	mov rsi, input
	mov rcx, r13

.shift_loop:
	movzx rax, byte [rsi]

	cmp al, 'a'
	jl .check_upper
	cmp al, 'z'
	jg .next
	mov rbx, 'a'
	jmp .shift

.check_upper:
	cmp al, 'A'
	jl .next
	cmp al, 'Z'
	jg .next
	mov rbx, 'A'

.shift:
	sub rax, rbx
	add rax, r12
	cmp rax, 26
	jl .store
	sub rax, 26

.store:
	add rax, rbx
	mov [rsi], al

.next:
	inc rsi
	dec rcx
	jnz .shift_loop

	mov rax, 1
	mov rdi, 1
	mov rsi, input
	mov rdx, r13
	syscall
	jmp .read_loop

.done:
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
	jz .end

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
	jmp .next_char

.sub_digit:
	sub rax, rcx
	jo _error1

.next_char:
	inc rsi
	jmp .loop

.end:
	cmp rdx, 0
	je _error1
	ret

_error1:
	mov rax, 60
	mov rdi, 1
	syscall

_error2:
	mov rax, 60
	mov rdi, 2
	syscall
