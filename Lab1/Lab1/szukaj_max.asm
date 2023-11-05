.686
.model flat

public _szukaj_max
public _szukaj4_max

.code

_szukaj_max PROC
    push ebp
    mov ebp, esp
    
    mov eax, [ebp + 8]
    cmp eax, [ebp + 12]
    jge x_wieksza

    mov eax, [ebp + 12]
    cmp eax, [ebp + 16]
    jge koniec
    
wpisz_z:
    mov eax, [ebp + 16]
    jmp koniec

x_wieksza:
    cmp eax, [ebp + 16]
    jge koniec
    jmp wpisz_z

koniec:
    pop ebp
    ret
_szukaj_max ENDP

_szukaj4_max PROC
    push ebp
    mov ebp, esp

    mov eax, [ebp + 8]
    push eax
    mov eax, [ebp + 12]
    push eax
    mov eax, [ebp + 16]
    push eax
    call _szukaj_max
    add esp, 12

    cmp eax, [ebp + 20]
    jge koniec2
    mov eax, [ebp + 20]
koniec2:
    pop ebp
    ret
_szukaj4_max ENDP

END