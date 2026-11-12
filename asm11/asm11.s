global _start

section .bss
	input resb 256
	buffer resb 32

section .text
_start:
	xor r12, r12

.read_loop:
	mov rax, 0
	mov rdi, 0
	mov rsi, input
	mov rdx, 256
	syscall

	cmp rax, 0
	jle .print_count

	mov rcx, rax
	mov rsi, input

.count_loop:
	mov al, byte [rsi]
	or al, 0x20

	cmp al, 'a'
	je .is_vowel
	cmp al, 'e'
	je .is_vowel
	cmp al, 'i'
	je .is_vowel
	cmp al, 'o'
	je .is_vowel
	cmp al, 'u'
	je .is_vowel
	jmp .next

.is_vowel:
	inc r12

.next:
	inc rsi
	dec rcx
	jnz .count_loop
	jmp .read_loop

.print_count:
	mov rax, r12
	call print_num

	mov rax, 60
	mov rdi, 0
	syscall

print_num:
	mov rsi, buffer + 31
	mov byte [rsi], 10
	mov r9, 10

.convert:
	dec rsi
	xor rdx, rdx
	div r9
	add dl, '0'
	mov [rsi], dl
	test rax, rax
	jnz .convert

	mov rdx, buffer + 32
	sub rdx, rsi

	mov rax, 1
	mov rdi, 1
	syscall
	ret
