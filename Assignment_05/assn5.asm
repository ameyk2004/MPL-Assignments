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

    hellomsg db "Welcome to Calculator",10,13
    hellomsglen equ $-hellomsg

    menu db 10,13,10,13,"Menu",10,13
         db "1. Addition",10,13
         db "2. Subtraction",10,13
         db "3. Multiplication",10,13
         db "4. Division",10,13
         db "5. Exit",10,13
    menulen equ $-menu

    addmsg db "Addition = "
    addlen equ $-addlen

    submsg db "Subtraction = "
    sublen equ $-sublen

    promsg db "Product = "
    prolen equ $-prolen

    quomsg db "Quotient = "
    quolen equ $-quolen

    remmsg db "Remainder = "
    remlen equ $-remlen

    num1 dq 0000000000000001h
    num2 dq 0000000000000006h

    result dq 0000000000000000h
    quotient dq 0000000000000000h
    remainder dq 0000000000000000h
    count db 00h

section .bss
    resultarr resb 16
    opt resb 2

section .text
    global _start
    _start:

    disp hellomsg, hellomsglen

    menulooop:
    disp menu, menulen
    read opt,02

    cmp opt, 31h
    jne checksub
    call addprocedure
    call htoa
    jmp menulooop

    checksub:
    cmp opt, 32h
    jne checkmul
    call subprocedure
    call htoa
    jmp menulooop

    checkmul:
    cmp opt, 33h
    jne checkdiv
    call mulprocedure
    call htoa
    jmp menulooop

    checkdiv:
    cmp opt, 34h
    jne checkexit
    call divprocedure
    jmp menulooop

    checkexit
    cmp opt, 35h
    jne menulooop
    jmp exit

    exit : 
    mov rax, 60
    mov rdi, 0
    syscall



    addprocedure:
    mov rax, qword[num1]
    add rax, qword[num2]
    mov qword[result], rax
    ret

    subprocedure:
    mov rax, qword[num1]
    sub rax, qword[num2]
    mov qword[result], rax
    ret

    mulprocedure:
    mov rax, qword[num1]
    mov ebx, dword[num2]
    mul ebx
    mov qword[result], rax
    ret

    divprocedure:
    xor rax, rax
    xor rdx, rdx
    xor rbx, rbx
    mov rax, qword[num1]
    mov ebx, dword[num2]

    div ebx

    mov qword[quotient], rax
    mov qword[remainder], rdx

    disp quomsg, quolen
    mov rax, qword[quotient]
    mov qword[result],rax
    call htoa

    disp remmsg, remlen
    mov rax, qword[remainder]
    mov qword[result],rax
    call htoa

    ret


    htoa:
    mov rbp, resultarr
    mov rax, qword[result]
    mov byte[count], 16

    label1:
    rol rax, 04
    mov bl,al
    and bl,0F
    cmp bl, 09
    jle label2
    add bl, 07

    label2:
    add bl, 30
    mov [rbp], bl
    inc rbp
    dec byte[count]
    jnz label1
    disp resultarr, 16
    ret



    


