; nie dziala dla -2^32
; 1000 0000 0000 0000 0000 0000 0000 0000 not
; 0111 1111 1111 1111 1111 1111 1111 1111 +1
; 1000 0000 0000 0000 0000 0000 0000 0000
wyswietl_eax_u2_b13 PROC
    pushad
    sub esp, 12
    mov edi, esp
    
    xor ebp, ebp
    test eax, 80000000h
    jz plus
    mov byte ptr [edi], '-'
    neg eax
    jmp dalej13
plus:
    mov byte ptr [edi], '+'
dalej13:
    mov byte ptr [edi + 11], 0ah

    mov ebx, 13
    mov esi, 10
konwersja13:
    xor edx, edx
    div ebx
    mov cl, [dekoder + edx]
    mov [edi + esi], cl
    dec esi
    test eax, eax
    jnz konwersja13

reszta13:
    mov byte ptr [edi + esi], 0
    dec esi
    jnz reszta13

    push dword ptr 12
    push edi
    push dword ptr 1
    call __write
    add esp, 24
    popad
    ret
wyswietl_eax_u2_b13 ENDP

wczytaj_eax_u2_b13 PROC
    push esi
    push edi
    push ebp
    push ecx
    push ebx
    sub esp, 12
    mov esi, esp

    push dword ptr 12
    push esi
    push dword ptr 0
    call __read
    add esp, 12

    xor edi, edi
    cmp byte ptr [esi], '-'
    jne plus_wczytaj
    mov ebp, 1
    inc edi
    jmp dalej_wczytaj
plus_wczytaj:
    xor ebp, ebp
    cmp byte ptr [esi], '+'
    jne dalej_wczytaj
    inc edi

dalej_wczytaj:
    xor eax, eax
    xor ecx, ecx
    mov ebx, 13
konwersja_wczytaj:
    mov cl, [esi + edi]
    cmp cl, 0ah
    je koniec
    mul ebx
    cmp cl, 'a'
    jb duze_znaki_wczytaj
    sub ecx, 'a' - 10
    jmp reszta_konwersji_wczytaj
duze_znaki_wczytaj:
    cmp cl, 'A'
    jb cyfry_wczytaj
    sub ecx, 'A' - 10
    jmp reszta_konwersji_wczytaj
cyfry_wczytaj:
    sub ecx, '0'
reszta_konwersji_wczytaj:
    add eax, ecx
    inc edi
    cmp edi, 12
    je koniec
    jmp konwersja_wczytaj

koniec:
    test ebp, ebp
    jz koniec_koniec
    neg eax
koniec_koniec:
    add esp, 12
    pop ebx
    pop ecx
    pop ebp
    pop edi
    pop esi
    ret
wczytaj_eax_u2_b13 ENDP

_main PROC
    call wczytaj_eax_u2_b13
    sub eax, 10
    call wyswietl_eax_u2_b13

    push DWORD PTR 0
    call _ExitProcess@4
_main ENDP

END