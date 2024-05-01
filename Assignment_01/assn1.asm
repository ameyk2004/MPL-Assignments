%macro disp 2
    mov rax, 1
    mov rdi, 1
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro

%macro readnum 2
    mov rax, 0
    mov rdi, 0
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro


section .data
    msg1 db "Enter a number : ",10,13
    msglen1 equ $-msg1
    msg2 db "Entered Numbers are : ",10,13
    msglen2 equ $-msg2

    count db 05
 
section .bss
    numarr resb 85


section .text
global _start
       _start:

       mov byte[count], 05h
       mov rbp, numarr

loop1:
    disp msg1, msglen1
    readnum rbp, 17
    add rbp,17
    dec byte[count]
    jnz loop1

mov byte[count], 05
mov rbp, numarr

loop2:
    disp rbp,17
    add rbp,17
    dec byte[count]
    jnz loop2


    mov rsi, 60
    mov rdi, 0
    syscall