.model tiny
.386
 
.data
pass1 db '12345'
len1 = $-pass1
pass2 db 10,0,10 dup(?)
msg1  db 0Dh,0Ah,'true$'
msg2  db 0Dh,0Ah,'false$'
 
.code
org	100h
start: 
		; Clear the screen
		mov ax, 0600h
		mov bh, 7h
		mov cx, 0000
		mov dx, 184fh
		int 10h

		; Set the position of cursor
		mov ah, 02
		mov bh, 00
		mov dl, 00
		mov dh, 00
		int 10h

		mov ah, 03Fh ; Function to read the file
		mov cx, 128 ; MaxLengthOfUsersString
		mov 	dx, offset pass2
		int 	21h
 
    mov al,len1
    cmp al,[pass2+1]
    jne wrong
 
    cld
    lea si,pass1
    lea di,pass2+2
    xor cx,cx
    mov cl,len1
    check:
        lodsb
        cmp al,byte ptr [di]
        je step
 
        jmp wrong
        
        step:
        inc di
    loop check
 
    good:
    mov ah,09h
    lea dx,msg1
    int 21h
    
    jmp exit    
 
    wrong:
    mov ah,09h
    lea dx,msg2
    int 21h
 
    exit:
    mov ah,4Ch
    mov al,0
    int 21h
end start