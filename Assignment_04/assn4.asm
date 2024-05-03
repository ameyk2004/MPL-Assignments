 %macro print 2
    mov rax,1
    mov rdi,1
    mov rsi,%1
    mov rdx,%2
    syscall
%endmacro
   
       
%macro exit 0
    mov rax,60
    mov rdi,0
    syscall
 %endmacro

section .data
    msg db "array Elements are:",0xa,0xd
    msglen equ $-msg

    msg2 db "",0xa,0xd
    msglen2 equ $-msg2

    msg3 db "The largest number is:"
    msglen3 equ $-msg3

    array dq 000000000000000Ah,0000000000000007h,0000000000000003h,000000000000000Bh,0000000000000005h

section .bss

    counter resb 1
    max resb 20

section .text
    global _start
_start:
 print msg,msglen


;print array elements

mov byte[counter],05h
mov rbp,array
back: mov al,[rbp]
Call display
inc rbp
dec byte[counter]
jnz back

;find largest number

print msg3,msglen3
mov byte[counter],05h
mov rbp,array
xor rax,rax
b1: cmp al,[rbp]
ja  go
mov al,[rbp]
  go:   inc rbp
         dec byte[counter]
         jnz b1

        call display

exit




display:    mov rbx,rax
       mov cx,16
       mov rsi,max
       
    back2: Rol rbx,04H
          mov al,bl
          AND al,0FH
          cmp al,09H
          jle add_30
          add al,07H
     
    add_30: add al,30H
       
    skip: mov byte[rsi],al
         add rsi,01
         dec cx
         jnz back2

print max,16
print msg2,msglen2
ret 