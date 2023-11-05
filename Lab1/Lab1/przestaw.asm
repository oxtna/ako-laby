.686
.model flat

public _przestaw

.code

_przestaw PROC
	push ebp
	mov ebp, esp
	push ebx

	mov ebx, [ebp + 8]
	mov ecx, [ebp + 12]
	dec ecx

petla:
	mov eax, [ebx]
	cmp eax, [ebx + 4]
	jle gotowe
	mov edx, [ebx + 4]
	mov [ebx], edx
	mov [ebx + 4], eax

gotowe:
	add ebx, 4
	loop petla

	pop ebx
	pop ebp
	ret
_przestaw ENDP

END