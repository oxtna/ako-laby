.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC
extern __read : PROC
public _main

.data

znaki db 12 dup (?)

obszar db 12 dup (?)
dziesiec dd 10

dekoder db '0123456789ABCDEF'

.code

wczytaj_do_eax PROC
    push dword ptr 12
    push dword ptr offset obszar
    push dword ptr 0
    call __read
    add esp, 12

    xor eax, eax
    mov ebx, offset obszar

pobieraj_znaki:
    mov cl, [ebx]
    inc ebx
    cmp cl, 10 
    je byl_enter
    and cl, 0fh
    movzx ecx, cl

    mul dword ptr dziesiec
    add eax, ecx
    jmp pobieraj_znaki

byl_enter:
    pop edx
    pop ecx
    pop ebx
    popfd
    ret
wczytaj_do_eax ENDP

wczytaj_do_eax_hex PROC
    push ebx
    push ecx
    push edx
    push esi
    push edi
    push ebp

    sub esp, 12
    mov esi, esp

    push dword ptr 10
    push esi
    push dword ptr 0
    call __read
    add esp, 12

    mov eax, 0
pocz_konw:
    mov dl, [esi]
    inc esi
    cmp dl, 0ah
    je gotowe
    cmp dl, '0'
    jb pocz_konw
    cmp dl, '9'
    ja sprawdzaj_dalej
    sub dl, '0'

dopisz:
    shl eax, 4
    or al, dl
    jmp pocz_konw

sprawdzaj_dalej:
    cmp dl, 'A'
    jb pocz_konw
    cmp dl, 'F'
    ja sprawdzaj_dalej2
    sub dl, 'A' - 10
    jmp dopisz

sprawdzaj_dalej2:
    cmp dl, 'a'
    jb pocz_konw
    cmp dl, 'f'
    ja pocz_konw
    sub dl, 'a' - 10
    jmp dopisz

gotowe:
    add esp, 12
    pop ebp
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret
wczytaj_do_eax_hex ENDP

wyswietl_eax PROC
    pushfd
    push eax
    push ebx
    push edx
    push esi
    mov esi, 10
    mov ebx, 10

konwersja:
    xor edx, edx
    div ebx
    add dl, 30h
    mov [znaki + esi], dl
    dec esi
    cmp eax, 0
    jne konwersja
    
wypeln:
    or esi, esi
    jz wyswietl
    mov byte ptr [znaki + esi], 20h
    dec esi
    jmp wypeln
wyswietl:
    mov byte ptr [znaki], 0ah
    mov byte ptr [znaki + 11], 0ah

    push dword ptr 12
    push dword ptr offset znaki
    push dword ptr 1
    call __write
    add esp, 12

    pop esi
    pop edx
    pop ebx
    pop eax
    popfd
    ret
wyswietl_eax ENDP

wyswietl_eax_hex PROC
    pushad
    sub esp, 12
    mov edi, esp

    mov ecx, 8
    mov esi, 1
ptl:
    rol eax, 4
    mov ebx, eax
    and ebx, 0Fh
    mov dl, [dekoder + ebx]
    mov [edi + esi], dl
    inc esi
    loop ptl

    mov esi, 1
ptl2:
    cmp byte ptr [edi + esi], 30h
    jne nie_jest_zero
    mov byte ptr [edi + esi], 20h
    inc esi
    jmp ptl2

nie_jest_zero:
    mov byte ptr [edi], 0ah
    mov byte ptr [edi + 9], 0ah

    push dword ptr 10
    push edi
    push dword ptr 1
    call __write
    add esp, 12 + 12
    popad
    ret
wyswietl_eax_hex ENDP

COMMENT @
; ECX : EDX : EAX / 10
wyswietl_96 PROC
    pushad
    sub esp, 44
    mov edi, esp
    
    mov [edi + 32], ecx
    mov [edi + 36], edx
    mov [edi + 40], eax

    mov ebx, 10
    mov esi, 10
    mov eax, ecx

    ; to jest chyba zle, bo przesuwam w prawo liczbe w ECX
    ; a to pierwsza reszta z dzielenia powinna chyba byc doklejona do EDX
    ; w nastepnym etapie
    xor edx, edx
    div ebx
    test eax, eax
    jz druga
    add dl, 30h
    mov [edi + esi], dl
    dec esi
    
druga:
    mov esi, 20
    mov eax, [edi + 36]
    div ebx
    add dl, 30h
    mov [edi + esi], dl
    dec esi

    mov [edi], 0ah
    mov [edi + 3], 0ah
    push dword ptr 4
    push edi
    push dword ptr 1
    call __write
    add esp, 56
    popad
    ret
wyswietl_96 ENDP
@

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