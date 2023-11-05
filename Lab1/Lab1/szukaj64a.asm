public szukaj64_max

.code

szukaj64_max PROC
	push rbx
	push rsi

	mov rbx, rcx
	mov rcx, rdx
	xor rsi, rsi

	mov rax, [rbx + rsi * 8]
	dec rcx

petla:
	inc rsi
	cmp rax, [rbx + rsi * 8]
	jge dalej
	mov rax, [rbx + rsi * 8]
dalej:
	loop petla

	pop rsi
	pop rbx
	ret
szukaj64_max ENDP

END