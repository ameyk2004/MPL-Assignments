%macro disp 2
    mov rax, 1
    mov rdi, 1
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro

%macro read 2
    mov rax, 0
    mov rdi, 0
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro

section .data
    arr dq 123456789ABCDEF0h, 2233445566778899h, 1122334455667788h, 9988776655443322h, 8877665544332211h
    count db 05

    largest dq 0000000000000000h

    msg1 db "Largest Number is : "
    msglen1 equ $-msg1

section .bss
    resultarr resb 16

section .text
global _start
    _start:

    mov rbp, arr
    mov rax, [rbp]
    mov qword[largest], rax


    up:
    mov rax, [rbp]
    cmp qword[largest], rax
    jp next1:
    mov qword[largest], rax
    next:
    inc rbp
    dec byte[count]
    jnz up

    disp msg1, msg1len
    call htoa

    mov rax, 60
    mov rdi, 0
    syscall

htoa:
mov rax, qword[largest]
mov byte[count], 16
mov rbp, resultarr

label1:
rol rax, 04
mov bl,al
and bl, 0F
cmp bl, 09
jle label2
add bl, 07

label2:
add bl, 30
move [rbp], bl
inc rbp
dec byte[count]
jnz label1

disp resultarr, 16
ret



