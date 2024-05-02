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
    msg1 db 10,13,"Enter a String : "
    msg1len equ $-msg1

    msg2 db 10,13,"Length : "
    msg2len equ $-msg2

    count db 16

section .bss
    str1 resb 20
    resultarr resb 16
    

section .text
    global _start
    _start:

    disp msg1, msg1len
    read str1, 20

    ;rax madhe Length store zhaliye 
    ;hex form madhe
    ;ata aplyala hex to ascii hex karaychay

    ;rax ----> QUAD WORD
    
mov rbp, resultarr
move byte[count], 16 

up:    ;rax -> 2038262038262038
rol rax, 04 
mov bl, al
and bl, 0F
cmp bl, 09
jle next1
add bl, 07

next1:
add bl, 30
move [rbp], bl
inc rbp
dec byte[count]
jnz up


disp msg2, msg2len
disp resultarr, 16

mov rax,60
mov rdi, 0
syscall











