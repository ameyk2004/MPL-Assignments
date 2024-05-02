%macro rw 4
    mov rax, %1
    mov rdi, %2
    mov rsi, %3
    mov rdx, %4
    syscall
%endmacro


section .data
    extern occmessage, occlen, nl, nlen

section .bss

    extern spctr, nlctr, chrctr, ctr1, ctr2, ctr3, buffer

section .text
    global functions

    functions:
    global spaces, enters, occurences

    spaces:
        mov rsi, buffer

        up: mov al, byte[rsi]
            cmp al, 20h
            je space_inc
            inc rsi
            dec byte[ctr1]
            jnz up

            jmp displaySpaces


        space_inc:
        inc rsi
        inc byte[spctr]
        dec byte[ctr1]
        jnz up

        displaySpaces:
        add byte[spctr], 30
        rw 1,1,spctr,2
        rw,1,1,nl, nlen

    enters:
        mov rsi, buffer

        enter_up: mov al, byte[rsi]
                  cmp al, 0Ah
                  je ent_inc
                  inc rsi
                  dec byte[ctr2]
                  jnz enter_up
                  
        ent_inc:
        inc rsi
        inc nlctr
        dec byte[ctr2]
        jnz enter_up
        




