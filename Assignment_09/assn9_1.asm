%macro rw 4
    mov rax, %1
    mov rdi, %2
    mov rsi, %3
    mov rdx, %4
    syscall
%endmacro

section .data

    global occmessage, occlen, nl, nlen


    filename db "hello.txt"
    fileopenmsg db "File opened successfully",10,13
    fileopenlen equ $-fileopenmsg

    fileclosemsg db "File closed successfully",10,13
    filecloselen equ $-fileclosemsg

    fileerrormsg db "File error opening",10,13
    fileerrorlen equ $-fileerrormsg

    spacesmsg db "Spces = "
    spacesmsglen equ $-spacesmsg

    entmsg db "New Lines = ",10,13
    entmsglen equ $-entmsg

    ipcharmessage db "Enter a char : "
    ipcharmessagelen equ $-ipcharmessage

    occmessage db "Number of occ = "
    occlen equ $-occmessage

    nl db 10,13
    nlen equ $-nl

section .bss

    global spctr, nlctr, chrctr, ctr1, ctr2, ctr3, buffer
    spctr resb 2
    nlctr resb 2
    chrctr resb 2
    chlen resb 2 ; character count

    fd resb 17
    buffer resb 200
    buff_len resb 17

    ctr1 resb 2
    ctr2 resb 2
    ctr3 resb 2
    cha resb 2

section .text
    global _start
    _start

    extern spaces, enters, occurences

    mov rax, 2 
    mov rdi, filename
    mov rsi, 2
    mov rdx, 0777

    move qword[fd], rax

    bt rax, 63
    jnc success
    rw,1,1,fileerrormsg.fileerrorlen
    jmp exit


    success: 
    rw,1,1,fileopenmsg, fileopenlen
    rw, 0, [fd], buffer, 200

    mov qword[buff_len], rax

    mov qword[ctr1], rax
    mov qword[ctr2], rax
    mov qword[ctr3], rax

    rw,1,1,spacesmsg, spacesmsglen
    call spaces

    rw,1,1, entmsg, entmsglen
    call enters

    rw,1,1,ipcharmessage, ipcharmessagelen
    rw,0,0,cha,2
    xor rbx,rbx
    mov bl,byte[cha]
    call occurences

    exit: 
    mov rax, 60
    mov rdi, 0
    syscall
