%macro disp 2
mov rax, 1
mov rdi, 1
mov rsi, %1
mov rdx, %2
syscall
%endmacro

section .data
    msg1 db "Positive Number count : ",10,13
    msg1len equ $-msg1

    msg2 db "Negative Number count : ",10,13
    msg2len equ $-msg2

    res db 00h
    pcount db 00h
    ncount db 00h
    count db 05


    arr dq 22276ABC73394C2Bh, 63DEACBF721E1211h, 0ERFF1233061A8888h, 1F89232222224444h, 1141122223333444h


section .bss

    resultarr resb 02

section .text
    global _start
    _start:

    mov rbp, arr

    up:
    mov rax, [rbp]
    bt rax, 63
    jc negative
    inc byte[pcount]
    jmp next1

    negative:
    inc byte[ncount]

    
    next1: inc rbp
    dec byte[count]
    jnz up

    disp msg1, msg1len
    mov al, byte[pcount]
    mov byte[res], al
    call htoa

    disp msg2, msg2len
    mov al, byte[ncount]
    mov byte[res], al
    call htoa

    mov rax, 60
    mov rdi, 00
    syscall

    htoa:     ;res --> 05
    move al, byte[res]
    move byte[count], 03
    mov rbp, resultarr

    label1:
    rol al, 04
    mov bl, al
    and bl, 0F
    cmp bl, 09
    jle label2
    add bl,07

    label2:
    add bl,30
    move [rbp], bl
    inc rbp
    dec byte[count]
    jnz label1

    disp resultarr, 02

    ret











    






