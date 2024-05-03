%macro rw 4
    mov rax, %1
    mov rdi, %2
    mov rsi, %3
    mov rdx, %4
    syscall
%endmacro


%macro exit 0
    mov rax, 60
    mov rdi, 0
    syscall
%endmacro


section .data
    num1 dq 01h
    num2 dq 05h
    
    result dq 0000000000000000h

    hellomsg db " Welcome to Calculator ",10,13,10,13
    hellolen equ $-hellomsg

    resultmsg db "Result = "
    reslen equ $-resultmsg

    menu db 0xa,0xd,"----MENU----"
        db 0xA,0xD,"1. Addition"
        db 0xA,0xD,"2. Subraction"
        db 0xA,0xD,"3. Multiplication"
        db 0xA,0xD,"4. Division"
        db 0xA,0xD,"5. Exit"
        db 0xA,0xD
        db 0xA,0xD,"Enter your choice:"


section .bss
    resultarr db 16
    choice db 02
    count resb 01


section .text
    global _start
    _start:

    dispmenu: 
    rw 1,1,menu,menulen
    rw 0,0, choice, 2

    cmp choice, 31h
    jne checksub
    call addprocedure
    call htoa
    jmp dispmenu

    checksub:
    cmp choice, 32h
    jne checkexit
    call subprocedure
    call htoa
    jmp dispmenu

    checkexit:
    cmp choice, 33h
    jne dispmenus
    jmp exit



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

    htoa:
    mov rax, qword[result]
    move byte[count], 16
    mov rbp, resultarr

    label1:
    rol rax, 04
    mov bl,al
    and bl, 0FH
    cmp bl, 09H
    jle next1
    add bl, 07H

    next1:
    add bl, 30h
    mov [rbp], bl
    inc rbp
    dec byte[count]

    jnz label1

    rw 1,1,resultarr,16
    ret















