pop rbx
pop rbx
xor rax,rax
pop rbx ; rbx madhe num stored



factr:
    cmp rax, 01h
    je retcon1
    push rax
    dec rax
    call factr


    retcon:
    pop rbx
    mul ebx
    jmp endpr

    retcon1:
    pop rbx
    jmp retcon

    endpr:
    ret

