section .data
	startmsg db 10,"Processor status display:",0xa, 0xd
	startmsglen equ $-startmsg
	
	exitmsg db "Exiting Program. (No errors encountered)",0xa, 0xd
	exitmsglen equ $-exitmsg
	
	cpumodemsg1 db "Mode of Processor: PROTECTED",0xa, 0xd
	cpumodemsglen1 equ $-cpumodemsg1
		
	cpumodemsg2 db "Mode of Processor: REAL MODE",0xa, 0xd
	cpumodemsg2len equ $-cpumodemsg2
	
	gdtrmsg db 10,"GDTR Contents are : "
	gdtrmsglen equ $-gdtrmsg
	
	ldtrmsg db 10,10,"LDTR Contents are : "
	ldtrmsglen equ $-ldtrmsg
	
	idtrmsg db 10,10,"IDTR Contents are : "
	idtrmsglen equ $-idtrmsg
	
	trmsg db 10,10,"TR Contents are   : "
	trmsglen equ $-trmsg
	
	mswmsg db 10,10,"MSW Contents are  : "
	mswmsglen equ $-mswmsg

	cpustat db 10,10, "CPUID is: "
	cpustatlen equ $-cpustat

	msg db 0xa, 0xd
	msglen equ $-msg
	colon db ':'
	

section .bss

		gdtrsave resb 6
		ldtrsave resb 2
		idtrsave resb 6
		trsave resb 2
		mswsave resb 4
		d4save	resb 4
		vendorString resb 13

%macro rw 3
	mov rax,%1
	mov rdi,%1
	mov rsi,%2
	mov rdx,%3
	syscall

%endmacro

section .text

global _start
_start:

	rw 01,startmsg,startmsglen
	smsw eax					; instruction for MSW
	BT	eax,0
	JC	protec
	rw 01,cpumodemsg2,cpumodemsg2len
	JMP exit
	
protec:

		rw 01,cpumodemsg1,cpumodemsglen1
		JMP skip

skip:
	
		sgdt [gdtrsave]
		sldt [ldtrsave]
		sidt [idtrsave]
		str	 [trsave]
		smsw [mswsave]
		
		;=========================== display gdtr contents ================================
		rw 01,gdtrmsg,gdtrmsglen
		
		mov bx,[gdtrsave + 4]
		call disp4 
		
		mov bx,[gdtrsave + 2]
		call disp4
		
		rw 01,colon,1
		
		mov bx,[gdtrsave]
		call disp4

		;=========================== display LDTR contents ================================
		
		rw 01, ldtrmsg,ldtrmsglen
		
		mov bx,[ldtrsave]
		call disp4
		
		;=========================== display IDTR contents ================================
		
		rw 01,idtrmsg,idtrmsglen
		
		mov bx,[idtrsave + 4]
		call disp4 
		
		mov bx,[idtrsave + 2]
		call disp4
		
		rw 01,colon,1
		
		mov bx,[idtrsave]
		call disp4	
		
		;=========================== Display TR contents ================================
		
		rw 01,trmsg,trmsglen
				
		mov bx,[trsave]
		call disp4
		
		;=========================== Display MSW contents ================================
		
		rw 01, mswmsg,mswmsglen
		
		
		mov bx,[mswsave + 2]
		call disp4
		
		rw 01, colon,1
		
		mov bx,[mswsave]
		call disp4

		;==========================  Display CPU ID data  ================================

		rw 01, cpustat, cpustatlen
		call getVendorString 
		rw 01, vendorString, 12



exit:
	rw 01, msg, msglen
	rw 01,exitmsg,exitmsglen
	mov rax,60
	mov rdi,0
	syscall	 	
	
	
disp4:
	mov rdi,d4save
	mov RCX,4

d4up:
	
	rol bx,4
	mov al,bl
	and al,0fh	
	add al,30h
	cmp al,39h
	jbe d4skip
	add al,07h
	
d4skip:

	mov [rdi],al
	inc rdi
	loop d4up
	rw 01,d4save,4
	ret

getVendorString:	
	mov dword[vendorString], 0
	mov eax, 0	; moving function number 0 in eax
	CPUID 
	mov dword[vendorString+0], ebx
	mov dword[vendorString+4], edx
	mov dword[vendorString+8], ecx
	ret
