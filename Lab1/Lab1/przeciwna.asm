.686
.model flat

public _liczba_przeciwna

public _odejmij_jeden

.code

_odejmij_jeden PROC
    push ebp
    mov ebp, esp
    push ebx
    push eax

    mov ebx, [ebp + 8]
    mov eax, [ebx]
    mov ebx, [eax]

    dec ebx
    mov [eax], ebx

    pop eax
    pop ebx
    pop ebp
    ret
_odejmij_jeden ENDP

_liczba_przeciwna PROC
    push ebp
    mov ebp, esp
    push ebx
    push eax

    mov ebx, [ebp + 8]
    mov eax, [ebx]
    neg eax
    mov [ebx], eax

    pop eax
    pop ebx
    pop ebp
    ret
_liczba_przeciwna ENDP

END