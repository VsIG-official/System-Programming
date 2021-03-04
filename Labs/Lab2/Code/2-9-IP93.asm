; Processors
.model tiny
.386

.data?

; Data Segment
.data	
	StartingText DB "Введiть пароль. Попереджаю, що у Вас є лише 3 спроби: $"
	FailureText DB "Пароль невiрний. $"
	
	StringFromUser DB 128 DUP (?)
	StringFromUser2 db 10,0,10 dup(?)
	
	; We can write password in two ways:
	Password  DB '123'
	
	; And another one is:
	; Password  DB 31h 32h 33h
	
	PasswordCount = $-Password
	;MaxLengthOfUsersString DB 128
	
	; Text To Show
	InformationText DB "ПIБ = Домiнський Валентин Олексiйович", 10, 
		"Дата Народження = 22.02.2002", 10,
		"Номер Залiковки книжки = 9311 $", 0
	
; Code Segment
.code
	org	100h ; this is offset for com programs:
	; It defines where the machine code (translated 
	; assembly program) is to place in memory.
	; As for org 100h this deals with 80x86 COM 
	; program format (COMMAND) which consist 
	; of only one segment of max. 64k bytes. 
	; 100h says that the machine code starts from 
	; address (offset) 100h in this segment.
	; For com format the offset is always 100h
	
.startup ; Generates program start-up code
	InvitePoint:	; Starting Code
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

		; Display The Text
		mov dx, offset StartingText
		mov ah, 9h
		int 21h
		
		jmp InputOfTheUser

	; Responsible For Input
	InputOfTheUser:
    mov ah,0Ah
    lea dx,StringFromUser2
    int 21h

		mov al,PasswordCount
		cmp al,[StringFromUser2+1];2
        jne WrongPasswordByUser

		cld
		lea si,Password
		lea di,StringFromUser2+2;2
		xor cx,cx
		mov cl,PasswordCount
		check:
			lodsb
			cmp al,byte ptr [di]
			je step
 
			jmp WrongPasswordByUser
        
			step:
			inc di
    loop check
 
	; Responsible For Correct Input
	CorrectPasswordByUser:
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
	
		mov ah,09h
		lea dx, InformationText
		int 21h
	
		jmp ExitCode
	
	; Responsible For Wrong Input
	WrongPasswordByUser:
		mov ah,09h
		lea dx, FailureText
		int 21h
		
	; Responsible For Exit
	ExitCode:
		; For exiting program We can use this code or...
		;mov ah, 4Ch
		;mov al, 00h
		;int 21h
		
		; ... this one
		.exit
end